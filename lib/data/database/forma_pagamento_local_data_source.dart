import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

class FormaPagamentoLocalDataSource {
  final DatabaseService _databaseService;

  FormaPagamentoLocalDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  Future<Result<void>> replaceAll(
    List<FormaPagamentoResponse> formasPagamento,
  ) async {
    try {
      final db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.delete(DatabaseService.formaPagamentoTable);

        final nowIso = DateTime.now().toUtc().toIso8601String();
        for (final formaPagamento in formasPagamento) {
          await txn.insert(
            DatabaseService.formaPagamentoTable,
            _toRow(formaPagamento)..['updated_at'] = nowIso,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<FormaPagamentoResponse>> obterPorId(int id) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.formaPagamentoTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rows.isEmpty) {
        return Result.failure(['Forma de pagamento não encontrada']);
      }

      final formaPagamento = _fromRow(rows.first);
      return Result.success(formaPagamento);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsert(FormaPagamentoResponse formaPagamento) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        DatabaseService.formaPagamentoTable,
        _toRow(formaPagamento)
          ..['updated_at'] = DateTime.now().toUtc().toIso8601String(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<FormaPagamentoResponse>>> listar({
    int? formaPagamentoId,
  }) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.formaPagamentoTable,
        where: formaPagamentoId != null ? 'formaPagamentoId = ?' : null,
        whereArgs: formaPagamentoId != null ? [formaPagamentoId] : null,
        orderBy: 'descricaoFormaPagamento ASC',
      );

      final formasPagamento = rows.map(_fromRow).toList();
      return Result.success(formasPagamento);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  FormaPagamentoResponse _fromRow(Map<String, Object?> row) {
    return FormaPagamentoResponse(
      id: row['id'] as int,
      descricaoFormaPagamento: row['descricaoFormaPagamento'] as String?,
    );
  }

  Map<String, Object?> _toRow(FormaPagamentoResponse formaPagamento) {
    return {
      'id': formaPagamento.id,
      'descricaoFormaPagamento': formaPagamento.descricaoFormaPagamento,
    };
  }
}

final formaPagamentoLocalDataSourceProvider =
    Provider<FormaPagamentoLocalDataSource>((ref) {
      final databaseService = ref.watch(databaseProvider);
      return FormaPagamentoLocalDataSource(databaseService: databaseService);
    });
