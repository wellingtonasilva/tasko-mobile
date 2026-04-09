import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/agenda_visita_checkin_local_data_source.dart';
import 'package:tasko_mobile/data/database/agenda_visita_local_data_source.dart';
import 'package:tasko_mobile/data/database/cliente_local_data_source.dart';
import 'package:tasko_mobile/data/database/pedido_local_data_source.dart';
import 'package:tasko_mobile/data/database/sync_queue_data_source.dart';
import 'package:tasko_mobile/data/database/vendedor_local_data_source.dart';
import 'package:tasko_mobile/data/service/agenda_visita_checkin_service.dart';
import 'package:tasko_mobile/data/service/agenda_visita_service.dart';
import 'package:tasko_mobile/data/service/cliente_service.dart';
import 'package:tasko_mobile/data/service/pedido_item_service.dart';
import 'package:tasko_mobile/data/service/pedido_service.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_checkin_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/atualizar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_checkin_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/data/service/vendedor_service.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/result.dart';

class SyncQueueWorker {
  SyncQueueWorker({
    required SyncQueueDataSource queueDataSource,
    required VendedorLocalDataSource vendedorLocalDataSource,
    required VendedorService vendedorService,
    required ClienteLocalDataSource clienteLocalDataSource,
    required ClienteService clienteService,
    required PedidoLocalDataSource pedidoLocalDataSource,
    required PedidoService pedidoService,
    required PedidoItemService pedidoItemService,
    required AgendaVisitaLocalDataSource agendaVisitaLocalDataSource,
    required AgendaVisitaService agendaVisitaService,
    required AgendaVisitaCheckinLocalDataSource
    agendaVisitaCheckinLocalDataSource,
    required AgendaVisitaCheckinService agendaVisitaCheckinService,
  }) : _queue = queueDataSource,
       _vendedorLocal = vendedorLocalDataSource,
       _vendedorService = vendedorService,
       _clienteLocal = clienteLocalDataSource,
       _clienteService = clienteService,
       _pedidoLocal = pedidoLocalDataSource,
       _pedidoService = pedidoService,
       _pedidoItemService = pedidoItemService,
       _agendaVisitaLocal = agendaVisitaLocalDataSource,
       _agendaVisitaService = agendaVisitaService,
       _agendaVisitaCheckinLocal = agendaVisitaCheckinLocalDataSource,
       _agendaVisitaCheckinService = agendaVisitaCheckinService;

  static const _maxAttempts = 6;
  static const _baseRetrySeconds = 5;
  static const _entityTypeVendedor = 'vendedor';
  static const _entityTypeCliente = 'cliente';
  static const _entityTypePedido = 'pedido';
  static const _entityTypeAgendaVisita = 'agenda_visita';
  static const _entityTypeAgendaVisitaCheckin = 'agenda_visita_checkin';

  final SyncQueueDataSource _queue;
  final VendedorLocalDataSource _vendedorLocal;
  final VendedorService _vendedorService;
  final ClienteLocalDataSource _clienteLocal;
  final ClienteService _clienteService;
  final PedidoLocalDataSource _pedidoLocal;
  final PedidoService _pedidoService;
  final PedidoItemService _pedidoItemService;
  final AgendaVisitaLocalDataSource _agendaVisitaLocal;
  final AgendaVisitaService _agendaVisitaService;
  final AgendaVisitaCheckinLocalDataSource _agendaVisitaCheckinLocal;
  final AgendaVisitaCheckinService _agendaVisitaCheckinService;

  Future<Result<void>> runOnce({int limit = 20}) async {
    final dueItemsResult = await _queue.getDueItems(limit: limit);
    if (dueItemsResult is Failure<List<SyncQueueItem>>) {
      return Result.failure(dueItemsResult.errors);
    }

    final items = (dueItemsResult as Success<List<SyncQueueItem>>).value;

    for (final item in items) {
      final markProcessingResult = await _queue.markProcessing(item.id);
      if (markProcessingResult is Failure<void>) {
        continue;
      }

      final processResult = await _processItem(item);
      if (processResult is Success<void>) {
        await _queue.markDone(item.id);
        continue;
      }

      final errors = (processResult as Failure<void>).errors;
      final errorMessage = (errors != null && errors.isNotEmpty)
          ? errors.first
          : 'Falha desconhecida durante sincronizacao';

      final nextAttemptCount = item.attemptCount + 1;
      if (!_isRetryableError(errorMessage) ||
          nextAttemptCount >= _maxAttempts) {
        await _queue.markDead(
          id: item.id,
          attemptCount: nextAttemptCount,
          error: errorMessage,
        );
        continue;
      }

      await _queue.scheduleRetry(
        id: item.id,
        attemptCount: nextAttemptCount,
        delay: _computeBackoff(nextAttemptCount),
        error: errorMessage,
      );
    }

    return Result.success(null);
  }

  Future<Result<void>> _processItem(SyncQueueItem item) async {
    if (item.payload == null || item.payload!.isEmpty) {
      return Result.failure(['Payload vazio na fila de sincronizacao']);
    }

    try {
      final payload = jsonDecode(item.payload!) as Map<String, dynamic>;

      switch (item.entityType) {
        case _entityTypeVendedor:
          switch (item.operation) {
            case 'add':
              return await _processVendedorAdd(item, payload);
            case 'update':
              return await _processVendedorUpdate(item, payload);
            default:
              return Result.success(null);
          }
        case _entityTypeCliente:
          switch (item.operation) {
            case 'add':
              return await _processClienteAdd(item, payload);
            case 'update':
              return await _processClienteUpdate(item, payload);
            case 'delete':
              return await _processClienteDelete(item);
            default:
              return Result.success(null);
          }
        case _entityTypePedido:
          switch (item.operation) {
            case 'add':
              return await _processPedidoAdd(item, payload);
            case 'delete':
              return await _processPedidoDelete(item);
            default:
              return Result.success(null);
          }
        case _entityTypeAgendaVisita:
          switch (item.operation) {
            case 'add':
              return await _processAgendaVisitaAdd(item, payload);
            case 'update':
              return await _processAgendaVisitaUpdate(item, payload);
            case 'delete':
              return await _processAgendaVisitaDelete(item);
            default:
              return Result.success(null);
          }
        case _entityTypeAgendaVisitaCheckin:
          switch (item.operation) {
            case 'add':
              return await _processAgendaVisitaCheckinAdd(item, payload);
            default:
              return Result.success(null);
          }
        default:
          return Result.success(null);
      }
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processClienteAdd(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = AdicionarClienteRequest.fromJson(payload);
      final result = await _clienteService.adicionar(request);

      if (result is Failure<ClienteResponse>) {
        return Result.failure(result.errors);
      }

      final remote = (result as Success<ClienteResponse>).value;
      final localId = int.tryParse(item.entityId);
      if (localId == null) {
        return Result.failure([
          'Entity id invalido para sincronizacao de create',
        ]);
      }

      final reconcileResult = await _clienteLocal.reconcileOfflineCreate(
        localId: localId,
        remote: remote,
      );
      if (reconcileResult is Failure<void>) {
        return reconcileResult;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processClienteUpdate(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = AtualizarClienteRequest.fromJson(payload);
      final result = await _clienteService.atualizar(request.id, request);

      if (result is Failure<ClienteResponse>) {
        return Result.failure(result.errors);
      }

      final remote = (result as Success<ClienteResponse>).value;
      final persistedResult = await _clienteLocal.upsert(remote);
      if (persistedResult is Failure<void>) {
        return persistedResult;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processClienteDelete(SyncQueueItem item) async {
    try {
      final id = int.tryParse(item.entityId);
      if (id == null) {
        return Result.failure(['Entity id invalido para exclusao de cliente']);
      }

      final result = await _clienteService.excluir(id);
      if (result is Failure<void>) {
        return result;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processVendedorAdd(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = AdicionarVendedorRequest.fromJson(payload);
      final result = await _vendedorService.adicionar(request);

      if (result is Failure<VendedorResponse>) {
        return Result.failure(result.errors);
      }

      final remote = (result as Success<VendedorResponse>).value;
      final localId = int.tryParse(item.entityId);
      if (localId == null) {
        return Result.failure([
          'Entity id invalido para sincronizacao de create',
        ]);
      }

      final reconcileResult = await _vendedorLocal.reconcileOfflineCreate(
        localId: localId,
        remote: remote,
      );
      if (reconcileResult is Failure<void>) {
        return reconcileResult;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processVendedorUpdate(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = AtualizarVendedorRequest.fromJson(payload);
      final result = await _vendedorService.atualizar(request.id, request);

      if (result is Failure<VendedorResponse>) {
        return Result.failure(result.errors);
      }

      final remote = (result as Success<VendedorResponse>).value;
      final persistedResult = await _vendedorLocal.upsert(remote);
      if (persistedResult is Failure<void>) {
        return persistedResult;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processPedidoAdd(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = AdicionarPedidoRequest.fromJson(payload);
      final result = await _pedidoService.adicionar(request);

      if (result is Failure<PedidoResponse>) {
        return Result.failure(result.errors);
      }

      final remote = (result as Success<PedidoResponse>).value;
      final localId = int.tryParse(item.entityId);
      if (localId == null) {
        return Result.failure([
          'Entity id invalido para sincronizacao de create',
        ]);
      }

      // Get local items before reconciling (which deletes local pedido row)
      final localItensResult = await _pedidoLocal.listarItensPorPedidoId(
        localId,
      );
      final localItens = localItensResult is Success<List<PedidoItemResponse>>
          ? localItensResult.value
          : <PedidoItemResponse>[];

      // Reconcile: replace local negative-ID pedido with server ID
      final reconcileResult = await _pedidoLocal.reconcileOfflineCreate(
        localId: localId,
        remote: remote,
      );
      if (reconcileResult is Failure<void>) {
        return reconcileResult;
      }

      // POST each item with the server pedidoId
      for (final localItem in localItens) {
        final itemRequest = AdicionarPedidoItemRequest(
          pedidoId: remote.id,
          produtoId: localItem.produtoId,
          quantidade: localItem.quantidade,
          precoUnitario: localItem.precoUnitario,
          percentualDesconto: localItem.percentualDesconto,
          valorDesconto: localItem.valorDesconto,
          valorTotal: localItem.valorTotal,
        );

        final itemResult = await _pedidoItemService.adicionar(itemRequest);
        if (itemResult is Success<PedidoItemResponse>) {
          await _pedidoLocal.upsertItem(itemResult.value);
        }
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processPedidoDelete(SyncQueueItem item) async {
    try {
      final id = int.tryParse(item.entityId);
      if (id == null) {
        return Result.failure(['Entity id invalido para exclusao de pedido']);
      }

      final result = await _pedidoService.excluir(id);
      if (result is Failure<void>) {
        return result;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processAgendaVisitaAdd(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = AdicionarAgendaVisitaRequest.fromJson(payload);
      final result = await _agendaVisitaService.adicionar(request);

      if (result is Failure<AgendaVisitaResponse>) {
        return Result.failure(result.errors);
      }

      final remote = (result as Success<AgendaVisitaResponse>).value;
      final localId = int.tryParse(item.entityId);
      if (localId == null) {
        return Result.failure([
          'Entity id invalido para sincronizacao de create',
        ]);
      }

      final reconcileResult = await _agendaVisitaLocal.reconcileOfflineCreate(
        localId: localId,
        remote: remote,
      );
      if (reconcileResult is Failure<void>) {
        return reconcileResult;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processAgendaVisitaUpdate(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    try {
      final id = payload['id'] as int?;
      if (id == null) {
        return Result.failure(['Id invalido no payload de update']);
      }

      final request = AtualizarAgendaVisitaRequest.fromJson(payload);
      final result = await _agendaVisitaService.atualizar(id, request);

      if (result is Failure<AgendaVisitaResponse>) {
        return Result.failure(result.errors);
      }

      final remote = (result as Success<AgendaVisitaResponse>).value;
      final persistedResult = await _agendaVisitaLocal.upsert(remote);
      if (persistedResult is Failure<void>) {
        return persistedResult;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processAgendaVisitaDelete(SyncQueueItem item) async {
    try {
      final id = int.tryParse(item.entityId);
      if (id == null) {
        return Result.failure([
          'Entity id invalido para exclusao de agenda visita',
        ]);
      }

      final result = await _agendaVisitaService.excluir(id);
      if (result is Failure<void>) {
        return result;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> _processAgendaVisitaCheckinAdd(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    try {
      final request = AdicionarAgendaVisitaCheckinRequest.fromJson(payload);
      final result = await _agendaVisitaCheckinService.adicionar(request);

      if (result is Failure<AgendaVisitaCheckinResponse>) {
        return Result.failure(result.errors);
      }

      final remote = (result as Success<AgendaVisitaCheckinResponse>).value;
      final localId = int.tryParse(item.entityId);
      if (localId == null) {
        return Result.failure([
          'Entity id invalido para sincronizacao de create',
        ]);
      }

      final reconcileResult = await _agendaVisitaCheckinLocal
          .reconcileOfflineCreate(localId: localId, remote: remote);
      if (reconcileResult is Failure<void>) {
        return reconcileResult;
      }

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Duration _computeBackoff(int attempt) {
    final expSeconds = _baseRetrySeconds * pow(2, max(0, attempt - 1)).toInt();
    final cappedSeconds = expSeconds > 300 ? 300 : expSeconds;
    return Duration(seconds: cappedSeconds);
  }

  bool _isRetryableError(String error) {
    final normalized = error.toLowerCase();
    return normalized.contains('socket') ||
        normalized.contains('timeout') ||
        normalized.contains('failed host lookup') ||
        normalized.contains('connection refused') ||
        normalized.contains('network') ||
        normalized.contains('handshake') ||
        normalized.contains('clientexception');
  }
}

final syncQueueWorkerProvider = Provider<SyncQueueWorker>((ref) {
  final queueDataSource = ref.watch(syncQueueDataSourceProvider);
  final vendedorLocalDataSource = ref.watch(vendedorLocalDataSourceProvider);
  final vendedorService = ref.watch(vendedorServiceProvider);
  final clienteLocalDataSource = ref.watch(clienteLocalDataSourceProvider);
  final clienteService = ref.watch(clienteServiceProvider);
  final pedidoLocalDataSource = ref.watch(pedidoLocalDataSourceProvider);
  final pedidoService = ref.watch(pedidoServiceProvider);
  final pedidoItemService = ref.watch(pedidoItemServiceProvider);
  final agendaVisitaLocal = ref.watch(agendaVisitaLocalDataSourceProvider);
  final agendaVisitaService = ref.watch(agendaVisitaServiceProvider);
  final agendaVisitaCheckinLocal = ref.watch(
    agendaVisitaCheckinLocalDataSourceProvider,
  );
  final agendaVisitaCheckinService = ref.watch(
    agendaVisitaCheckinServiceProvider,
  );

  return SyncQueueWorker(
    queueDataSource: queueDataSource,
    vendedorLocalDataSource: vendedorLocalDataSource,
    vendedorService: vendedorService,
    clienteLocalDataSource: clienteLocalDataSource,
    clienteService: clienteService,
    pedidoLocalDataSource: pedidoLocalDataSource,
    pedidoService: pedidoService,
    pedidoItemService: pedidoItemService,
    agendaVisitaLocalDataSource: agendaVisitaLocal,
    agendaVisitaService: agendaVisitaService,
    agendaVisitaCheckinLocalDataSource: agendaVisitaCheckinLocal,
    agendaVisitaCheckinService: agendaVisitaCheckinService,
  );
});
