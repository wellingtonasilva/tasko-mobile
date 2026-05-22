import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

class CondicaoPagamentoLocalDataSource {
  final DatabaseService _databaseService;

  CondicaoPagamentoLocalDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  Future<Result<void>> replaceAll(
    List<CondicaoPagamentoResponse> condicoes,
  ) async {
    try {
      final db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.delete(DatabaseService.condicaoPagamentoTable);

        final nowIso = DateTime.now().toUtc().toIso8601String();
        for (final condicao in condicoes) {
          await txn.insert(
            DatabaseService.condicaoPagamentoTable,
            _toRow(condicao)..['updated_at'] = nowIso,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<CondicaoPagamentoResponse>> obterPorId(int id) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.condicaoPagamentoTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rows.isEmpty) {
        return Result.failure(['Condição de pagamento não encontrada']);
      }

      final condicaoPagamento = _fromRow(rows.first);
      return Result.success(condicaoPagamento);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsert(
    CondicaoPagamentoResponse condicaoPagamento,
  ) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        DatabaseService.condicaoPagamentoTable,
        _toRow(condicaoPagamento)
          ..['updated_at'] = DateTime.now().toUtc().toIso8601String(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<CondicaoPagamentoResponse>>> listar({
    int? formaPagamentoId,
  }) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.condicaoPagamentoTable,
        where: formaPagamentoId != null ? 'formaPagamentoId = ?' : null,
        whereArgs: formaPagamentoId != null ? [formaPagamentoId] : null,
        orderBy: 'descricaoCondicaoPagamento ASC',
      );

      final condicoes = rows.map(_fromRow).toList();
      return Result.success(condicoes);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  CondicaoPagamentoResponse _fromRow(Map<String, Object?> row) {
    return CondicaoPagamentoResponse(
      id: row['id'] as int,
      formaPagamentoId: row['formaPagamentoId'] as int?,
      descricaoCondicaoPagamento: row['descricaoCondicaoPagamento'] as String?,
      condicaoPagamento: row['condicaoPagamento'] as String?,
    );
  }

  Map<String, Object?> _toRow(CondicaoPagamentoResponse condicaoPagamento) {
    return {
      'id': condicaoPagamento.id,
      'formaPagamentoId': condicaoPagamento.formaPagamentoId,
      'descricaoCondicaoPagamento':
          condicaoPagamento.descricaoCondicaoPagamento,
      'condicaoPagamento': condicaoPagamento.condicaoPagamento,
    };
  }
}

final condicaoPagamentoLocalDataSourceProvider =
    Provider<CondicaoPagamentoLocalDataSource>((ref) {
      final databaseService = ref.watch(databaseProvider);
      return CondicaoPagamentoLocalDataSource(databaseService: databaseService);
    });
