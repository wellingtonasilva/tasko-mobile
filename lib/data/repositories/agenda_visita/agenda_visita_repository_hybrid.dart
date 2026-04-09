import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/agenda_visita_checkin_local_data_source.dart';
import 'package:tasko_mobile/data/database/agenda_visita_local_data_source.dart';
import 'package:tasko_mobile/data/database/sync_queue_data_source.dart';
import 'package:tasko_mobile/data/database/sync_queue_worker.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita/agenda_visita_repository.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita/agenda_visita_repository_remote.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_checkin_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/atualizar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_checkin_response.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaRepositoryHybrid implements AgendaVisitaRepository {
  AgendaVisitaRepositoryHybrid({
    required AgendaVisitaRepositoryRemote remote,
    required AgendaVisitaLocalDataSource local,
    required AgendaVisitaCheckinLocalDataSource checkinLocal,
    required SyncQueueDataSource syncQueue,
    required SyncQueueWorker syncQueueWorker,
  }) : _remote = remote,
       _local = local,
       _checkinLocal = checkinLocal,
       _syncQueue = syncQueue,
       _syncQueueWorker = syncQueueWorker;

  final AgendaVisitaRepositoryRemote _remote;
  final AgendaVisitaLocalDataSource _local;
  final AgendaVisitaCheckinLocalDataSource _checkinLocal;
  final SyncQueueDataSource _syncQueue;
  final SyncQueueWorker _syncQueueWorker;

  @override
  Future<Result<AgendaVisitaResponse>> adicionar(
    AdicionarAgendaVisitaRequest request,
  ) async {
    final remoteResult = await _remote.adicionar(request);
    if (remoteResult is Success<AgendaVisitaResponse>) {
      await _local.upsert(remoteResult.value);
      return remoteResult;
    }

    final failure = remoteResult as Failure<AgendaVisitaResponse>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localResult = await _local.upsertOfflineCreate(request);
    if (localResult is Failure<AgendaVisitaResponse>) {
      return localResult;
    }

    final localVisita = (localResult as Success<AgendaVisitaResponse>).value;
    final enqueueResult = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'agenda_visita:add:${localVisita.id}',
      entityType: 'agenda_visita',
      entityId: localVisita.id.toString(),
      operation: 'add',
      payload: request.toJson(),
      idempotencyKey: 'agenda_visita-add-${localVisita.id}',
    );
    if (enqueueResult is Failure<void>) {
      return Result.failure(enqueueResult.errors);
    }

    return Result.success(localVisita);
  }

  @override
  Future<Result<AgendaVisitaResponse>> atualizar(
    int id,
    AtualizarAgendaVisitaRequest request,
  ) async {
    final remoteResult = await _remote.atualizar(id, request);
    if (remoteResult is Success<AgendaVisitaResponse>) {
      await _local.upsert(remoteResult.value);
      return remoteResult;
    }

    final failure = remoteResult as Failure<AgendaVisitaResponse>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localResult = await _local.upsertOfflineUpdate(id, request);
    if (localResult is Failure<AgendaVisitaResponse>) {
      return localResult;
    }

    final localVisita = (localResult as Success<AgendaVisitaResponse>).value;

    if (localVisita.id < 0) {
      final addPayload = AdicionarAgendaVisitaRequest(
        dataAgendada: localVisita.dataAgendada.toIso8601String(),
        duracaoPrevista: localVisita.duracaoPrevista,
        objetivo: localVisita.objetivo,
        observacao: localVisita.observacao,
        vendedorId: localVisita.vendedorId,
        clienteId: localVisita.clienteId,
        agendaVisitaStatusId: localVisita.agendaVisitaStatusId,
        latitude: localVisita.latitude,
        longitude: localVisita.longitude,
        criadoOffline: true,
        uuidOffline: localVisita.uuidOffline,
      );

      final enqueueCreateResult = await _syncQueue.enqueueOrMerge(
        clientOperationId: 'agenda_visita:add:${localVisita.id}',
        entityType: 'agenda_visita',
        entityId: localVisita.id.toString(),
        operation: 'add',
        payload: addPayload.toJson(),
        idempotencyKey: 'agenda_visita-add-${localVisita.id}',
      );

      if (enqueueCreateResult is Failure<void>) {
        return Result.failure(enqueueCreateResult.errors);
      }

      return Result.success(localVisita);
    }

    final enqueueUpdateResult = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'agenda_visita:update:${localVisita.id}',
      entityType: 'agenda_visita',
      entityId: localVisita.id.toString(),
      operation: 'update',
      payload: {'id': id, ...request.toJson()},
      idempotencyKey: 'agenda_visita-update-${localVisita.id}',
    );
    if (enqueueUpdateResult is Failure<void>) {
      return Result.failure(enqueueUpdateResult.errors);
    }

    return Result.success(localVisita);
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
      clientOperationId: 'agenda_visita:delete:$id',
      entityType: 'agenda_visita',
      entityId: id.toString(),
      operation: 'delete',
      payload: {'id': id},
      idempotencyKey: 'agenda_visita-delete-$id',
    );

    if (enqueueDelete is Failure<void>) {
      return enqueueDelete;
    }

    return Result.success(null);
  }

  @override
  Future<Result<List<AgendaVisitaResponse>>> listar({int? vendedorId}) async {
    if (vendedorId != null) {
      final localResult = await _local.listar(vendedorId);
      if (localResult is Success<List<AgendaVisitaResponse>> &&
          localResult.value.isNotEmpty) {
        return localResult;
      }
    }

    final remoteResult = await _remote.listar(vendedorId: vendedorId);
    if (remoteResult is Success<List<AgendaVisitaResponse>>) {
      await _local.replaceAll(remoteResult.value);
      return remoteResult;
    }

    if (vendedorId != null) {
      return await _local.listar(vendedorId);
    }

    return remoteResult;
  }

  @override
  Future<Result<List<AgendaVisitaResponse>>> listarPorData(
    int vendedorId,
    DateTime data,
  ) async {
    final localResult = await _local.listarPorData(vendedorId, data);
    if (localResult is Success<List<AgendaVisitaResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listarPorData(vendedorId, data);
    if (remoteResult is Success<List<AgendaVisitaResponse>>) {
      await _local.upsertMany(remoteResult.value);
      return remoteResult;
    }

    return localResult;
  }

  @override
  Future<Result<AgendaVisitaResponse>> obterPorId(int id) async {
    final localResult = await _local.obterPorId(id);
    if (localResult is Success<AgendaVisitaResponse>) {
      return localResult;
    }

    final remoteResult = await _remote.obterPorId(id);
    if (remoteResult is Success<AgendaVisitaResponse>) {
      await _local.upsert(remoteResult.value);
    }
    return remoteResult;
  }

  @override
  Future<Result<AgendaVisitaCheckinResponse>> adicionarCheckin(
    AdicionarAgendaVisitaCheckinRequest request,
  ) async {
    final remoteResult = await _remote.adicionarCheckin(request);
    if (remoteResult is Success<AgendaVisitaCheckinResponse>) {
      await _checkinLocal.upsert(remoteResult.value);
      return remoteResult;
    }

    final failure = remoteResult as Failure<AgendaVisitaCheckinResponse>;
    if (!_shouldFallbackOffline(failure)) {
      return remoteResult;
    }

    final localResult = await _checkinLocal.upsertOfflineCreate(request);
    if (localResult is Failure<AgendaVisitaCheckinResponse>) {
      return localResult;
    }

    final localCheckin =
        (localResult as Success<AgendaVisitaCheckinResponse>).value;
    final enqueueResult = await _syncQueue.enqueueOrMerge(
      clientOperationId: 'agenda_visita_checkin:add:${localCheckin.id}',
      entityType: 'agenda_visita_checkin',
      entityId: localCheckin.id.toString(),
      operation: 'add',
      payload: request.toJson(),
      idempotencyKey: 'agenda_visita_checkin-add-${localCheckin.id}',
    );
    if (enqueueResult is Failure<void>) {
      return Result.failure(enqueueResult.errors);
    }

    return Result.success(localCheckin);
  }

  @override
  Future<Result<List<AgendaVisitaCheckinResponse>>> listarCheckins(
    int agendaVisitaId,
  ) async {
    final localResult = await _checkinLocal.listarPorVisita(agendaVisitaId);
    if (localResult is Success<List<AgendaVisitaCheckinResponse>> &&
        localResult.value.isNotEmpty) {
      return localResult;
    }

    final remoteResult = await _remote.listarCheckins(agendaVisitaId);
    if (remoteResult is Success<List<AgendaVisitaCheckinResponse>>) {
      await _checkinLocal.replaceAllForVisita(
        agendaVisitaId,
        remoteResult.value,
      );
      return remoteResult;
    }

    return localResult;
  }

  Future<Result<List<AgendaVisitaResponse>>> sincronizarListaComServidor({
    int? vendedorId,
  }) async {
    await _syncQueueWorker.runOnce();

    final remoteResult = await _remote.listar(vendedorId: vendedorId);
    if (remoteResult is Failure<List<AgendaVisitaResponse>>) {
      return remoteResult;
    }

    final visitas = (remoteResult as Success<List<AgendaVisitaResponse>>).value;
    final persistedResult = await _local.replaceAll(visitas);
    if (persistedResult is Failure<void>) {
      return Result.failure(persistedResult.errors);
    }

    if (vendedorId != null) {
      return _local.listar(vendedorId);
    }

    return Result.success(visitas);
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

final agendaVisitaRepositoryHybridProvider =
    Provider<AgendaVisitaRepositoryHybrid>((ref) {
      final remote = ref.watch(agendaVisitaRepositoryRemoteProvider);
      final local = ref.watch(agendaVisitaLocalDataSourceProvider);
      final checkinLocal = ref.watch(
        agendaVisitaCheckinLocalDataSourceProvider,
      );
      final syncQueue = ref.watch(syncQueueDataSourceProvider);
      final worker = ref.watch(syncQueueWorkerProvider);
      return AgendaVisitaRepositoryHybrid(
        remote: remote,
        local: local,
        checkinLocal: checkinLocal,
        syncQueue: syncQueue,
        syncQueueWorker: worker,
      );
    });
