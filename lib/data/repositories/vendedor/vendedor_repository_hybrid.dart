import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/sync_queue_data_source.dart';
import 'package:tasko_mobile/data/database/sync_queue_worker.dart';
import 'package:tasko_mobile/data/database/vendedor_local_data_source.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_remote.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorRepositoryHybrid implements VendedorRepository {
  VendedorRepositoryHybrid({
    required VendedorRepositoryRemote remote,
    required VendedorLocalDataSource local,
    required SyncQueueDataSource syncQueue,
    required SyncQueueWorker syncQueueWorker,
  }) : _remote = remote,
       _local = local,
       _syncQueue = syncQueue,
       _syncQueueWorker = syncQueueWorker;

  final VendedorRepositoryRemote _remote;
  final VendedorLocalDataSource _local;
  final SyncQueueDataSource _syncQueue;
  final SyncQueueWorker _syncQueueWorker;

  @override
  Future<Result<VendedorResponse>> adicionar(
    AdicionarVendedorRequest request,
  ) async {
    final remoteResult = await _remote.adicionar(request);
    if (remoteResult is Success<VendedorResponse>) {
      await _local.upsert(remoteResult.value);
      return remoteResult;
    }

    final failure = remoteResult as Failure<VendedorResponse>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localResult = await _local.upsertOfflineCreate(request);
    if (localResult is Failure<VendedorResponse>) {
      return localResult;
    }

    final localVendedor = (localResult as Success<VendedorResponse>).value;
    final enqueueResult = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'vendedor:add:${localVendedor.id}',
      entityType: 'vendedor',
      entityId: localVendedor.id.toString(),
      operation: 'add',
      payload: request.toJson(),
      idempotencyKey: 'vendedor-add-${localVendedor.id}',
    );
    if (enqueueResult is Failure<void>) {
      return Result.failure(enqueueResult.errors);
    }

    return Result.success(localVendedor);
  }

  @override
  Future<Result<VendedorResponse>> atualizar(
    int id,
    AtualizarVendedorRequest request,
  ) async {
    final remoteResult = await _remote.atualizar(id, request);
    if (remoteResult is Success<VendedorResponse>) {
      await _local.upsert(remoteResult.value);
      return remoteResult;
    }

    final failure = remoteResult as Failure<VendedorResponse>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localResult = await _local.upsertOfflineUpdate(request);
    if (localResult is Failure<VendedorResponse>) {
      return localResult;
    }

    final localVendedor = (localResult as Success<VendedorResponse>).value;

    if (localVendedor.id < 0) {
      final addPayload = AdicionarVendedorRequest(
        codigoVendedor: localVendedor.codigoVendedor,
        nomeVendedor: localVendedor.nomeVendedor,
        numeroCPF: localVendedor.numeroCPF,
        email: localVendedor.email,
        numeroTelefone: localVendedor.numeroTelefone,
        valorMetaMensal: localVendedor.valorMetaMensal ?? 0,
        percentualComissao: localVendedor.percentualComissao,
        supervisorId: localVendedor.supervisor?.id ?? 0,
        territorioId: localVendedor.territorio?.id ?? 0,
      );

      final enqueueCreateResult = await _syncQueue.enqueueOrMerge(
        clientOperationId: 'vendedor:add:${localVendedor.id}',
        entityType: 'vendedor',
        entityId: localVendedor.id.toString(),
        operation: 'add',
        payload: addPayload.toJson(),
        idempotencyKey: 'vendedor-add-${localVendedor.id}',
      );

      if (enqueueCreateResult is Failure<void>) {
        return Result.failure(enqueueCreateResult.errors);
      }

      return Result.success(localVendedor);
    }

    final enqueueUpdateResult = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'vendedor:update:${localVendedor.id}',
      entityType: 'vendedor',
      entityId: localVendedor.id.toString(),
      operation: 'update',
      payload: request.toJson(),
      idempotencyKey: 'vendedor-update-${localVendedor.id}',
    );
    if (enqueueUpdateResult is Failure<void>) {
      return Result.failure(enqueueUpdateResult.errors);
    }

    return Result.success(localVendedor);
  }

  @override
  Future<Result<void>> excluir(int id) async {
    final remoteResult = await _remote.excluir(id);
    if (remoteResult is Success<void>) {
      await _local.removerPorId(id);
    }
    return remoteResult;
  }

  @override
  Future<Result<List<VendedorResponse>>> listar() async {
    final localResult = await _local.listar();
    if (localResult is Success<List<VendedorResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listar();
    if (remoteResult is Success<List<VendedorResponse>>) {
      await _local.replaceAll(remoteResult.value);
      return remoteResult;
    }

    return remoteResult;
  }

  @override
  Future<Result<VendedorResponse>> obterPorId(int id) async {
    final localResult = await _local.obterPorId(id);
    if (localResult is Success<VendedorResponse>) {
      return localResult;
    }

    final remoteResult = await _remote.obterPorId(id);
    if (remoteResult is Success<VendedorResponse>) {
      await _local.upsert(remoteResult.value);
    }
    return remoteResult;
  }

  Future<Result<List<VendedorResponse>>> sincronizarListaComServidor() async {
    await _syncQueueWorker.runOnce();

    final remoteResult = await _remote.listar();
    if (remoteResult is Failure<List<VendedorResponse>>) {
      return remoteResult;
    }

    final vendedores = (remoteResult as Success<List<VendedorResponse>>).value;
    final persistedResult = await _local.replaceAll(vendedores);
    if (persistedResult is Failure<void>) {
      return Result.failure(persistedResult.errors);
    }

    return _local.listar();
  }

  bool _shouldFallbackOffline(Failure<VendedorResponse> failure) {
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

final vendedorRepositoryHybridProvider = Provider<VendedorRepositoryHybrid>((
  ref,
) {
  final remote = ref.watch(vendedorRepositoryRemoteProvider);
  final local = ref.watch(vendedorLocalDataSourceProvider);
  final syncQueue = ref.watch(syncQueueDataSourceProvider);
  final worker = ref.watch(syncQueueWorkerProvider);
  return VendedorRepositoryHybrid(
    remote: remote,
    local: local,
    syncQueue: syncQueue,
    syncQueueWorker: worker,
  );
});
