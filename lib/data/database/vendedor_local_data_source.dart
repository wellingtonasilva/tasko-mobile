import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorLocalDataSource {
  VendedorLocalDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;

  Future<Result<List<VendedorResponse>>> listar() async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.vendedoresTable,
        where: 'deleted = 0',
        orderBy: 'nome_vendedor ASC',
      );

      final vendedores = rows.map(_fromRow).toList();
      return Result.success(vendedores);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<VendedorResponse>> obterPorId(int id) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.vendedoresTable,
        where: 'id = ? AND deleted = 0',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return Result.failure(['Vendedor nao encontrado no banco local']);
      }

      return Result.success(_fromRow(rows.first));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsert(VendedorResponse vendedor) async {
    return upsertMany([vendedor], markAsDirty: false);
  }

  Future<Result<void>> upsertMany(
    List<VendedorResponse> vendedores, {
    bool markAsDirty = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final batch = db.batch();
      final nowIso = DateTime.now().toUtc().toIso8601String();

      for (final vendedor in vendedores) {
        batch.insert(
          DatabaseService.vendedoresTable,
          _toRow(vendedor, nowIso, markAsDirty: markAsDirty),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<VendedorResponse>> upsertOfflineCreate(
    AdicionarVendedorRequest request,
  ) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toUtc();
      final localId = -now.microsecondsSinceEpoch;
      final localUuid = 'vend-local-${now.microsecondsSinceEpoch}';

      final row = {
        'id': localId,
        'local_uuid': localUuid,
        'codigo_vendedor': request.codigoVendedor,
        'nome_vendedor': request.nomeVendedor,
        'numero_cpf': request.numeroCPF,
        'email': request.email,
        'numero_telefone': request.numeroTelefone,
        'valor_meta_mensal': request.valorMetaMensal,
        'percentual_comissao': request.percentualComissao,
        'ultimo_sincronismo': null,
        'codigo_dispositivo': null,
        'supervisor_id': request.supervisorId,
        'supervisor_nome': null,
        'territorio_id': request.territorioId,
        'territorio_nome': null,
        'auditoria_criado_em': now.toIso8601String(),
        'auditoria_atualizado_em': now.toIso8601String(),
        'auditoria_indicador_ativo': 1,
        'local_updated_at': now.toIso8601String(),
        'server_updated_at': null,
        'synced_at': null,
        'dirty': 1,
        'deleted': 0,
        'sync_error': null,
        'sync_attempt_count': 0,
      };

      await db.insert(
        DatabaseService.vendedoresTable,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Result.success(_fromRow(row));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<VendedorResponse>> upsertOfflineUpdate(
    AtualizarVendedorRequest request,
  ) async {
    try {
      final db = await _databaseService.database;
      final currentRows = await db.query(
        DatabaseService.vendedoresTable,
        where: 'id = ? AND deleted = 0',
        whereArgs: [request.id],
        limit: 1,
      );

      final existing = currentRows.isEmpty ? null : _fromRow(currentRows.first);
      final nowIso = DateTime.now().toUtc().toIso8601String();

      final merged = VendedorResponse(
        id: request.id,
        empresaId: request.empresaId,
        codigoVendedor: request.codigoVendedor,
        nomeVendedor: request.nomeVendedor,
        numeroCPF: request.numeroCPF,
        email: request.email,
        numeroTelefone: request.numeroTelefone,
        valorMetaMensal: request.valorMetaMensal,
        percentualComissao: request.percentualComissao,
        codigoDispositivo: request.codigoDispositivo,
        supervisor: request.supervisorId == null
            ? existing?.supervisor
            : VendedorSupervisorResponse(
                id: request.supervisorId!,
                nomeSupervisor: existing?.supervisor?.nomeSupervisor,
              ),
        territorio: request.territorioId == null
            ? existing?.territorio
            : VendedorTerritorioResponse(
                id: request.territorioId!,
                nomeTerritorio: existing?.territorio?.nomeTerritorio ?? '',
              ),
        auditoria:
            existing?.auditoria ??
            Auditoria(
              criadoEm: DateTime.now().toUtc(),
              atualizadoEm: DateTime.now().toUtc(),
              indicadorAtivo: request.indicadorAtivo,
            ),
      );

      final row = _toRow(merged, nowIso, markAsDirty: true);
      await db.insert(
        DatabaseService.vendedoresTable,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Result.success(_fromRow(row));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> reconcileOfflineCreate({
    required int localId,
    required VendedorResponse remote,
  }) async {
    try {
      final db = await _databaseService.database;
      final nowIso = DateTime.now().toUtc().toIso8601String();

      await db.transaction((txn) async {
        final localRows = await txn.query(
          DatabaseService.vendedoresTable,
          where: 'id = ?',
          whereArgs: [localId],
          limit: 1,
        );
        final localUuid = localRows.isEmpty
            ? null
            : localRows.first['local_uuid'] as String?;

        await txn.delete(
          DatabaseService.vendedoresTable,
          where: 'id = ?',
          whereArgs: [localId],
        );

        await txn.insert(
          DatabaseService.vendedoresTable,
          _toRow(remote, nowIso, markAsDirty: false, localUuid: localUuid),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> removerPorId(int id) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        DatabaseService.vendedoresTable,
        {
          'deleted': 1,
          'dirty': 1,
          'local_updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> replaceAll(List<VendedorResponse> vendedores) async {
    try {
      final db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.delete(DatabaseService.vendedoresTable);

        final nowIso = DateTime.now().toUtc().toIso8601String();
        for (final vendedor in vendedores) {
          await txn.insert(
            DatabaseService.vendedoresTable,
            _toRow(vendedor, nowIso, markAsDirty: false),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Map<String, Object?> _toRow(
    VendedorResponse vendedor,
    String nowIso, {
    required bool markAsDirty,
    String? localUuid,
  }) {
    final serverUpdatedAt =
        vendedor.auditoria?.atualizadoEm?.toUtc().toIso8601String() ??
        vendedor.ultimoSincronismo?.toUtc().toIso8601String();

    return {
      'id': vendedor.id,
      'local_uuid': localUuid ?? 'vend-${vendedor.id}',
      'codigo_vendedor': vendedor.codigoVendedor,
      'nome_vendedor': vendedor.nomeVendedor,
      'numero_cpf': vendedor.numeroCPF,
      'email': vendedor.email,
      'numero_telefone': vendedor.numeroTelefone,
      'valor_meta_mensal': vendedor.valorMetaMensal,
      'percentual_comissao': vendedor.percentualComissao,
      'ultimo_sincronismo': vendedor.ultimoSincronismo
          ?.toUtc()
          .toIso8601String(),
      'codigo_dispositivo': vendedor.codigoDispositivo,
      'supervisor_id': vendedor.supervisor?.id,
      'supervisor_nome': vendedor.supervisor?.nomeSupervisor,
      'territorio_id': vendedor.territorio?.id,
      'territorio_nome': vendedor.territorio?.nomeTerritorio,
      'auditoria_criado_em': vendedor.auditoria?.criadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_atualizado_em': vendedor.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_indicador_ativo': vendedor.auditoria?.indicadorAtivo == true
          ? 1
          : 0,
      'local_updated_at': nowIso,
      'server_updated_at': serverUpdatedAt,
      'synced_at': markAsDirty ? null : nowIso,
      'dirty': markAsDirty ? 1 : 0,
      'deleted': 0,
      'sync_error': null,
      'sync_attempt_count': markAsDirty ? 1 : 0,
    };
  }

  VendedorResponse _fromRow(Map<String, Object?> row) {
    final supervisorId = row['supervisor_id'] as int?;
    final territorioId = row['territorio_id'] as int?;

    return VendedorResponse(
      id: row['id'] as int,
      empresaId: row['empresa_id'] as int,
      codigoVendedor: row['codigo_vendedor'] as String,
      nomeVendedor: row['nome_vendedor'] as String,
      numeroCPF: row['numero_cpf'] as String,
      email: row['email'] as String,
      numeroTelefone: row['numero_telefone'] as String,
      valorMetaMensal: _toDouble(row['valor_meta_mensal']),
      percentualComissao: _toDouble(row['percentual_comissao']) ?? 0,
      ultimoSincronismo: _toDateTime(row['ultimo_sincronismo']),
      codigoDispositivo: row['codigo_dispositivo'] as String?,
      supervisor: supervisorId == null
          ? null
          : VendedorSupervisorResponse(
              id: supervisorId,
              nomeSupervisor: row['supervisor_nome'] as String?,
            ),
      territorio: territorioId == null
          ? null
          : VendedorTerritorioResponse(
              id: territorioId,
              nomeTerritorio: (row['territorio_nome'] as String?) ?? '',
            ),
      auditoria: Auditoria(
        criadoEm: _toDateTime(row['auditoria_criado_em']),
        atualizadoEm: _toDateTime(row['auditoria_atualizado_em']),
        indicadorAtivo: (row['auditoria_indicador_ativo'] as int?) == 1,
      ),
    );
  }

  DateTime? _toDateTime(Object? value) {
    if (value is! String || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value)?.toLocal();
  }

  double? _toDouble(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}

final vendedorLocalDataSourceProvider = Provider<VendedorLocalDataSource>((
  ref,
) {
  final databaseService = ref.watch(databaseProvider);
  return VendedorLocalDataSource(databaseService: databaseService);
});
