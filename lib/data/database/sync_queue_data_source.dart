import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/util/result.dart';

enum SyncQueueStatus { pending, processing, dead, done }

class SyncQueueItem {
  const SyncQueueItem({
    required this.id,
    required this.clientOperationId,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.idempotencyKey,
    required this.payload,
    required this.createdAt,
    required this.updatedAt,
    required this.nextRetryAt,
    required this.attemptCount,
    required this.status,
    this.lastAttemptAt,
    this.lastError,
  });

  final int id;
  final String clientOperationId;
  final String entityType;
  final String entityId;
  final String operation;
  final String idempotencyKey;
  final String? payload;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime nextRetryAt;
  final int attemptCount;
  final SyncQueueStatus status;
  final DateTime? lastAttemptAt;
  final String? lastError;

  factory SyncQueueItem.fromRow(Map<String, Object?> row) {
    return SyncQueueItem(
      id: row['id'] as int,
      clientOperationId: row['client_operation_id'] as String,
      entityType: row['entity_type'] as String,
      entityId: row['entity_id'] as String,
      operation: row['operation'] as String,
      idempotencyKey: row['idempotency_key'] as String,
      payload: row['payload'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(row['updated_at'] as String).toLocal(),
      nextRetryAt: DateTime.parse(row['next_retry_at'] as String).toLocal(),
      attemptCount: row['attempt_count'] as int,
      status: _parseStatus(row['status'] as String),
      lastAttemptAt: _parseDateTime(row['last_attempt_at']),
      lastError: row['last_error'] as String?,
    );
  }

  static SyncQueueStatus _parseStatus(String value) {
    return switch (value) {
      'pending' => SyncQueueStatus.pending,
      'processing' => SyncQueueStatus.processing,
      'dead' => SyncQueueStatus.dead,
      'done' => SyncQueueStatus.done,
      _ => SyncQueueStatus.pending,
    };
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value)?.toLocal();
  }
}

class SyncQueueDataSource {
  SyncQueueDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;

  Future<Result<void>> enqueueOrMerge({
    required String clientOperationId,
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toUtc();
      final nowIso = now.toIso8601String();
      final operationKey = idempotencyKey ?? clientOperationId;
      final payloadJson = jsonEncode(payload);

      final existing = await db.query(
        DatabaseService.syncQueueTable,
        where: 'client_operation_id = ? AND status IN (?, ?)',
        whereArgs: [clientOperationId, 'pending', 'processing'],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        await db.update(
          DatabaseService.syncQueueTable,
          {
            'payload': payloadJson,
            'updated_at': nowIso,
            'next_retry_at': nowIso,
            'last_error': null,
          },
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
        return Result.success(null);
      }

      final pendingByEntityAndOperation = await db.query(
        DatabaseService.syncQueueTable,
        where:
            'entity_type = ? AND entity_id = ? AND operation = ? AND status = ?',
        whereArgs: [entityType, entityId, operation, 'pending'],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      if (pendingByEntityAndOperation.isNotEmpty) {
        await db.update(
          DatabaseService.syncQueueTable,
          {
            'payload': payloadJson,
            'updated_at': nowIso,
            'next_retry_at': nowIso,
            'last_error': null,
          },
          where: 'id = ?',
          whereArgs: [pendingByEntityAndOperation.first['id']],
        );
        return Result.success(null);
      }

      await db.insert(DatabaseService.syncQueueTable, {
        'client_operation_id': clientOperationId,
        'entity_type': entityType,
        'entity_id': entityId,
        'operation': operation,
        'idempotency_key': operationKey,
        'payload': payloadJson,
        'created_at': nowIso,
        'updated_at': nowIso,
        'next_retry_at': nowIso,
        'last_attempt_at': null,
        'attempt_count': 0,
        'status': 'pending',
        'last_error': null,
      }, conflictAlgorithm: ConflictAlgorithm.abort);

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<SyncQueueItem>>> getDueItems({int limit = 20}) async {
    try {
      final db = await _databaseService.database;
      final nowIso = DateTime.now().toUtc().toIso8601String();
      final rows = await db.query(
        DatabaseService.syncQueueTable,
        where: 'status IN (?, ?) AND next_retry_at <= ?',
        whereArgs: ['pending', 'processing', nowIso],
        orderBy: 'created_at ASC',
        limit: limit,
      );

      final items = rows.map(SyncQueueItem.fromRow).toList();
      return Result.success(items);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> markProcessing(int id) async {
    return _updateStatus(
      id,
      status: 'processing',
      lastAttemptAt: DateTime.now().toUtc(),
    );
  }

  Future<Result<void>> markDone(int id) async {
    return _updateStatus(id, status: 'done', lastError: null);
  }

  Future<Result<void>> scheduleRetry({
    required int id,
    required int attemptCount,
    required Duration delay,
    required String error,
  }) async {
    final now = DateTime.now().toUtc();
    final nextRetry = now.add(delay);

    return _updateStatus(
      id,
      status: 'pending',
      attemptCount: attemptCount,
      nextRetryAt: nextRetry,
      lastError: error,
    );
  }

  Future<Result<void>> markDead({
    required int id,
    required int attemptCount,
    required String error,
  }) async {
    return _updateStatus(
      id,
      status: 'dead',
      attemptCount: attemptCount,
      lastError: error,
    );
  }

  Future<Result<void>> _updateStatus(
    int id, {
    required String status,
    int? attemptCount,
    DateTime? nextRetryAt,
    DateTime? lastAttemptAt,
    String? lastError,
  }) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        DatabaseService.syncQueueTable,
        {
          'status': status,
          'attempt_count': attemptCount,
          'next_retry_at': nextRetryAt?.toIso8601String(),
          'last_attempt_at': lastAttemptAt?.toIso8601String(),
          'last_error': lastError,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }..removeWhere((key, value) => value == null),
        where: 'id = ?',
        whereArgs: [id],
      );
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final syncQueueDataSourceProvider = Provider<SyncQueueDataSource>((ref) {
  final databaseService = ref.watch(databaseProvider);
  return SyncQueueDataSource(databaseService: databaseService);
});
