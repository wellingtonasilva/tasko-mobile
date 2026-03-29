import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/database/sync_queue_data_source.dart';
import 'package:tasko_mobile/data/database/vendedor_local_data_source.dart';
import 'package:tasko_mobile/data/service/vendedor_service.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/result.dart';

class SyncQueueWorker {
  SyncQueueWorker({
    required SyncQueueDataSource queueDataSource,
    required VendedorLocalDataSource vendedorLocalDataSource,
    required VendedorService vendedorService,
  }) : _queue = queueDataSource,
       _vendedorLocal = vendedorLocalDataSource,
       _vendedorService = vendedorService;

  static const _maxAttempts = 6;
  static const _baseRetrySeconds = 5;
  static const _entityTypeVendedor = 'vendedor';

  final SyncQueueDataSource _queue;
  final VendedorLocalDataSource _vendedorLocal;
  final VendedorService _vendedorService;

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
    if (item.entityType != _entityTypeVendedor) {
      return Result.success(null);
    }

    if (item.payload == null || item.payload!.isEmpty) {
      return Result.failure(['Payload vazio na fila de sincronizacao']);
    }

    try {
      final payload = jsonDecode(item.payload!) as Map<String, dynamic>;

      switch (item.operation) {
        case 'add':
          return await _processVendedorAdd(item, payload);
        case 'update':
          return await _processVendedorUpdate(item, payload);
        default:
          return Result.success(null);
      }
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

  return SyncQueueWorker(
    queueDataSource: queueDataSource,
    vendedorLocalDataSource: vendedorLocalDataSource,
    vendedorService: vendedorService,
  );
});
