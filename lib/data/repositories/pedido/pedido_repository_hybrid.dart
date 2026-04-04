import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/pedido_local_data_source.dart';
import 'package:tasko_mobile/data/database/sync_queue_data_source.dart';
import 'package:tasko_mobile/data/database/sync_queue_worker.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository_remote.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoRepositoryHybrid implements PedidoRepository {
  PedidoRepositoryHybrid({
    required PedidoRepositoryRemote remote,
    required PedidoLocalDataSource local,
    required SyncQueueDataSource syncQueue,
    required SyncQueueWorker syncQueueWorker,
  }) : _remote = remote,
       _local = local,
       _syncQueue = syncQueue,
       _syncQueueWorker = syncQueueWorker;

  final PedidoRepositoryRemote _remote;
  final PedidoLocalDataSource _local;
  final SyncQueueDataSource _syncQueue;
  final SyncQueueWorker _syncQueueWorker;

  @override
  Future<Result<PedidoResponse>> adicionar(
    AdicionarPedidoRequest request, {
    required List<AdicionarPedidoItemRequest> itens,
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
  }) async {
    final remoteResult = await _remote.adicionar(
      request,
      itens: itens,
      formaPagamentoNome: formaPagamentoNome,
      condicaoPagamentoNome: condicaoPagamentoNome,
      pedidoStatusTipoNome: pedidoStatusTipoNome,
    );

    if (remoteResult is Success<PedidoResponse>) {
      await _local.upsert(remoteResult.value);
      return remoteResult;
    }

    final failure = remoteResult as Failure<PedidoResponse>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localResult = await _local.upsertOfflineCreate(
      request,
      itens: itens,
      formaPagamentoNome: formaPagamentoNome,
      condicaoPagamentoNome: condicaoPagamentoNome,
      pedidoStatusTipoNome: pedidoStatusTipoNome,
    );

    if (localResult is Failure<PedidoResponse>) {
      return localResult;
    }

    final localPedido = (localResult as Success<PedidoResponse>).value;

    final enqueueResult = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'pedido:add:${localPedido.id}',
      entityType: 'pedido',
      entityId: localPedido.id.toString(),
      operation: 'add',
      payload: request.toJson(),
      idempotencyKey: 'pedido-add-${localPedido.id}',
    );

    if (enqueueResult is Failure<void>) {
      return Result.failure(enqueueResult.errors);
    }

    return Result.success(localPedido);
  }

  @override
  Future<Result<List<PedidoResponse>>> listar({int? vendedorId}) async {
    final localResult = await _local.listar(vendedorId: vendedorId);
    if (localResult is Success<List<PedidoResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listar(vendedorId: vendedorId);
    if (remoteResult is Success<List<PedidoResponse>>) {
      await _local.replaceAll(remoteResult.value);
      return remoteResult;
    }

    return remoteResult;
  }

  @override
  Future<Result<PedidoResponse>> obterPorId(int id) async {
    final localResult = await _local.obterPorId(id);
    if (localResult is Success<PedidoResponse>) {
      return localResult;
    }

    final remoteResult = await _remote.obterPorId(id);
    if (remoteResult is Success<PedidoResponse>) {
      await _local.upsert(remoteResult.value);
    }
    return remoteResult;
  }

  @override
  Future<Result<void>> excluir(int id) async {
    final remoteResult = await _remote.excluir(id);
    if (remoteResult is Success<void>) {
      await _local.removerPorId(id);
      return remoteResult;
    }

    final failure = remoteResult as Failure<void>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localDelete = await _local.removerPorId(id);
    if (localDelete is Failure<void>) {
      return localDelete;
    }

    final enqueueDelete = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'pedido:delete:$id',
      entityType: 'pedido',
      entityId: id.toString(),
      operation: 'delete',
      payload: {'id': id},
      idempotencyKey: 'pedido-delete-$id',
    );

    if (enqueueDelete is Failure<void>) {
      return enqueueDelete;
    }

    return Result.success(null);
  }

  @override
  Future<Result<PedidoItemResponse>> adicionarItem(
    AdicionarPedidoItemRequest request,
  ) {
    return _remote.adicionarItem(request);
  }

  @override
  Future<Result<List<PedidoItemResponse>>> listarItens(int pedidoId) {
    return _remote.listarItens(pedidoId);
  }

  @override
  Future<Result<void>> excluirItem(int itemId) {
    return _remote.excluirItem(itemId);
  }

  Future<Result<List<PedidoResponse>>> sincronizarListaComServidor({
    int? vendedorId,
  }) async {
    await _syncQueueWorker.runOnce();

    final remoteResult = await _remote.listar(vendedorId: vendedorId);
    if (remoteResult is Failure<List<PedidoResponse>>) {
      return remoteResult;
    }

    final pedidos = (remoteResult as Success<List<PedidoResponse>>).value;
    final persistedResult = await _local.replaceAll(pedidos);
    if (persistedResult is Failure<void>) {
      return Result.failure(persistedResult.errors);
    }

    return _local.listar(vendedorId: vendedorId);
  }

  bool _shouldFallbackOffline(Failure failure) {
    final errors = failure.errors;
    if (errors == null || errors.isEmpty) {
      return false;
    }

    final message = errors.first.toLowerCase();
    return message.contains('socket') ||
        message.contains('timeout') ||
        message.contains('failed host lookup') ||
        message.contains('connection refused') ||
        message.contains('network') ||
        message.contains('handshake') ||
        message.contains('clientexception');
  }
}

final pedidoRepositoryHybridProvider = Provider<PedidoRepositoryHybrid>((ref) {
  final remote = ref.watch(pedidoRepositoryRemoteProvider);
  final local = ref.watch(pedidoLocalDataSourceProvider);
  final syncQueue = ref.watch(syncQueueDataSourceProvider);
  final worker = ref.watch(syncQueueWorkerProvider);

  return PedidoRepositoryHybrid(
    remote: remote,
    local: local,
    syncQueue: syncQueue,
    syncQueueWorker: worker,
  );
});
