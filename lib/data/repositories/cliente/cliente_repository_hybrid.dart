import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/cliente_local_data_source.dart';
import 'package:tasko_mobile/data/database/sync_queue_data_source.dart';
import 'package:tasko_mobile/data/database/sync_queue_worker.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_remote.dart';
import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_tabela_preco_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteRepositoryHybrid implements ClienteRepository {
  ClienteRepositoryHybrid({
    required ClienteRepositoryRemote remote,
    required ClienteLocalDataSource local,
    required SyncQueueDataSource syncQueue,
    required SyncQueueWorker syncQueueWorker,
  }) : _remote = remote,
       _local = local,
       _syncQueue = syncQueue,
       _syncQueueWorker = syncQueueWorker;

  final ClienteRepositoryRemote _remote;
  final ClienteLocalDataSource _local;
  final SyncQueueDataSource _syncQueue;
  final SyncQueueWorker _syncQueueWorker;

  @override
  Future<Result<ClienteResponse>> adicionar(
    AdicionarClienteRequest request,
  ) async {
    final remoteResult = await _remote.adicionar(request);
    if (remoteResult is Success<ClienteResponse>) {
      await _local.upsert(remoteResult.value);
      return remoteResult;
    }

    final failure = remoteResult as Failure<ClienteResponse>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localResult = await _local.upsertOfflineCreate(request);
    if (localResult is Failure<ClienteResponse>) {
      return localResult;
    }

    final localCliente = (localResult as Success<ClienteResponse>).value;
    final enqueueResult = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'cliente:add:${localCliente.id}',
      entityType: 'cliente',
      entityId: localCliente.id.toString(),
      operation: 'add',
      payload: request.toJson(),
      idempotencyKey: 'cliente-add-${localCliente.id}',
    );
    if (enqueueResult is Failure<void>) {
      return Result.failure(enqueueResult.errors);
    }

    return Result.success(localCliente);
  }

  @override
  Future<Result<ClienteResponse>> atualizar(
    int id,
    AtualizarClienteRequest request,
  ) async {
    final remoteResult = await _remote.atualizar(id, request);
    if (remoteResult is Success<ClienteResponse>) {
      await _local.upsert(remoteResult.value);
      return remoteResult;
    }

    final failure = remoteResult as Failure<ClienteResponse>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localResult = await _local.upsertOfflineUpdate(request);
    if (localResult is Failure<ClienteResponse>) {
      return localResult;
    }

    final localCliente = (localResult as Success<ClienteResponse>).value;

    if (localCliente.id < 0) {
      final addPayload = AdicionarClienteRequest(
        vendedorId: localCliente.vendedorId,
        codigoCliente: localCliente.codigoCliente,
        razaoSocial: localCliente.razaoSocial,
        nomeFantasia: localCliente.nomeFantasia,
        cnpjCpf: localCliente.cnpjCpf,
        inscricaoEstadual: localCliente.inscricaoEstadual,
        tipo: localCliente.tipo,
        segmento: localCliente.segmento,
        categoria: localCliente.categoria,
        cep: localCliente.cep,
        logradouro: localCliente.logradouro,
        complemento: localCliente.complemento,
        bairro: localCliente.bairro,
        cidade: localCliente.cidade,
        estado: localCliente.estado,
        latitude: localCliente.latitude,
        longitude: localCliente.longitude,
        limiteCredito: localCliente.limiteCredito,
        prazoPagamento: localCliente.prazoPagamento,
        bloqueado: localCliente.bloqueado,
        motivoBloqueio: localCliente.motivoBloqueio,
      );

      final enqueueCreateResult = await _syncQueue.enqueueOrMerge(
        clientOperationId: 'cliente:add:${localCliente.id}',
        entityType: 'cliente',
        entityId: localCliente.id.toString(),
        operation: 'add',
        payload: addPayload.toJson(),
        idempotencyKey: 'cliente-add-${localCliente.id}',
      );

      if (enqueueCreateResult is Failure<void>) {
        return Result.failure(enqueueCreateResult.errors);
      }

      return Result.success(localCliente);
    }

    final enqueueUpdateResult = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'cliente:update:${localCliente.id}',
      entityType: 'cliente',
      entityId: localCliente.id.toString(),
      operation: 'update',
      payload: request.toJson(),
      idempotencyKey: 'cliente-update-${localCliente.id}',
    );
    if (enqueueUpdateResult is Failure<void>) {
      return Result.failure(enqueueUpdateResult.errors);
    }

    return Result.success(localCliente);
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
      clientOperationId: 'cliente:delete:$id',
      entityType: 'cliente',
      entityId: id.toString(),
      operation: 'delete',
      payload: {'id': id},
      idempotencyKey: 'cliente-delete-$id',
    );

    if (enqueueDelete is Failure<void>) {
      return enqueueDelete;
    }

    return Result.success(null);
  }

  @override
  Future<Result<List<ClienteResponse>>> listar({int? vendedorId}) async {
    final localResult = await _local.listar(vendedorId: vendedorId);
    if (localResult is Success<List<ClienteResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listar(vendedorId: vendedorId);
    if (remoteResult is Success<List<ClienteResponse>>) {
      await _local.replaceAll(remoteResult.value);
      return remoteResult;
    }

    return remoteResult;
  }

  @override
  Future<Result<ClienteResponse>> obterPorId(int id) async {
    final localResult = await _local.obterPorId(id);
    if (localResult is Success<ClienteResponse>) {
      return localResult;
    }

    final remoteResult = await _remote.obterPorId(id);
    if (remoteResult is Success<ClienteResponse>) {
      await _local.upsert(remoteResult.value);
    }
    return remoteResult;
  }

  @override
  Future<Result<List<ClienteTabelaPrecoResponse>>> listarTabelasPreco(
    int clienteId,
  ) {
    return _remote.listarTabelasPreco(clienteId);
  }

  Future<Result<List<ClienteResponse>>> sincronizarListaComServidor({
    int? vendedorId,
  }) async {
    await _syncQueueWorker.runOnce();

    final remoteResult = await _remote.listar(vendedorId: vendedorId);
    if (remoteResult is Failure<List<ClienteResponse>>) {
      return remoteResult;
    }

    final clientes = (remoteResult as Success<List<ClienteResponse>>).value;
    final persistedResult = await _local.replaceAll(clientes);
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

final clienteRepositoryHybridProvider = Provider<ClienteRepositoryHybrid>((
  ref,
) {
  final remote = ref.watch(clienteRepositoryRemoteProvider);
  final local = ref.watch(clienteLocalDataSourceProvider);
  final syncQueue = ref.watch(syncQueueDataSourceProvider);
  final worker = ref.watch(syncQueueWorkerProvider);

  return ClienteRepositoryHybrid(
    remote: remote,
    local: local,
    syncQueue: syncQueue,
    syncQueueWorker: worker,
  );
});
