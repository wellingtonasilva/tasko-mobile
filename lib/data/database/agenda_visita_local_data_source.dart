import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/atualizar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaLocalDataSource {
  AgendaVisitaLocalDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;

  Future<Result<List<AgendaVisitaResponse>>> listar(int vendedorId) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.agendaVisitasTable,
        where: 'vendedor_id = ? AND deleted = 0',
        whereArgs: [vendedorId],
        orderBy: 'data_agendada DESC',
      );

      final visitas = rows.map(_fromRow).toList();
      return Result.success(visitas);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<AgendaVisitaResponse>>> listarPorData(
    int vendedorId,
    DateTime data,
  ) async {
    try {
      final db = await _databaseService.database;
      final dataStr = data.toIso8601String().substring(0, 10);
      final rows = await db.query(
        DatabaseService.agendaVisitasTable,
        where: 'vendedor_id = ? AND deleted = 0 AND data_agendada LIKE ?',
        whereArgs: [vendedorId, '$dataStr%'],
        orderBy: 'data_agendada ASC',
      );

      final visitas = rows.map(_fromRow).toList();
      return Result.success(visitas);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaResponse>> obterPorId(int id) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.agendaVisitasTable,
        where: 'id = ? AND deleted = 0',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return Result.failure([
          'Agenda de visita nao encontrada no banco local',
        ]);
      }

      return Result.success(_fromRow(rows.first));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsert(AgendaVisitaResponse visita) async {
    return upsertMany([visita], markAsDirty: false);
  }

  Future<Result<void>> upsertMany(
    List<AgendaVisitaResponse> visitas, {
    bool markAsDirty = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final batch = db.batch();
      final nowIso = DateTime.now().toUtc().toIso8601String();

      for (final visita in visitas) {
        batch.insert(
          DatabaseService.agendaVisitasTable,
          _toRow(visita, nowIso, markAsDirty: markAsDirty),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaResponse>> upsertOfflineCreate(
    AdicionarAgendaVisitaRequest request,
  ) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toUtc();
      final localId = -now.microsecondsSinceEpoch;
      final localUuid = 'av-local-${now.microsecondsSinceEpoch}';

      final row = {
        'id': localId,
        'local_uuid': localUuid,
        'data_agendada': request.dataAgendada,
        'data_realizada': null,
        'duracao_prevista': request.duracaoPrevista,
        'duracao_real': null,
        'objetivo': request.objetivo,
        'observacao': request.observacao,
        'resultado': null,
        'vendedor_id': request.vendedorId,
        'cliente_id': request.clienteId,
        'agenda_visita_status_id': request.agendaVisitaStatusId,
        'agenda_visita_status_nome': null,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'pedido_gerado': 0,
        'pedido_id': null,
        'valor_pedido': null,
        'sincronizado': 0,
        'criado_offline': 1,
        'uuid_offline': request.uuidOffline ?? localUuid,
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
        DatabaseService.agendaVisitasTable,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Result.success(_fromRow(row));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaResponse>> upsertOfflineUpdate(
    int id,
    AtualizarAgendaVisitaRequest request,
  ) async {
    try {
      final db = await _databaseService.database;
      final currentRows = await db.query(
        DatabaseService.agendaVisitasTable,
        where: 'id = ? AND deleted = 0',
        whereArgs: [id],
        limit: 1,
      );

      if (currentRows.isEmpty) {
        return Result.failure([
          'Agenda de visita nao encontrada no banco local',
        ]);
      }

      final existing = _fromRow(currentRows.first);
      final nowIso = DateTime.now().toUtc().toIso8601String();

      final merged = AgendaVisitaResponse(
        id: existing.id,
        dataAgendada: existing.dataAgendada,
        dataRealizada: request.dataRealizada != null
            ? DateTime.tryParse(request.dataRealizada!)
            : existing.dataRealizada,
        duracaoPrevista: existing.duracaoPrevista,
        duracaoReal: request.duracaoReal ?? existing.duracaoReal,
        objetivo: existing.objetivo,
        observacao: request.observacao ?? existing.observacao,
        resultado: request.resultado ?? existing.resultado,
        vendedorId: existing.vendedorId,
        clienteId: existing.clienteId,
        agendaVisitaStatusId:
            request.agendaVisitaStatusId ?? existing.agendaVisitaStatusId,
        agendaVisitaStatusNome: existing.agendaVisitaStatusNome,
        latitude: existing.latitude,
        longitude: existing.longitude,
        pedidoGerado: existing.pedidoGerado,
        pedidoId: existing.pedidoId,
        valorPedido: existing.valorPedido,
        sincronizado: existing.sincronizado,
        criadoOffline: existing.criadoOffline,
        uuidOffline: existing.uuidOffline,
        auditoria: existing.auditoria,
      );

      final row = _toRow(merged, nowIso, markAsDirty: true);
      await db.insert(
        DatabaseService.agendaVisitasTable,
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
    required AgendaVisitaResponse remote,
  }) async {
    try {
      final db = await _databaseService.database;
      final nowIso = DateTime.now().toUtc().toIso8601String();

      await db.transaction((txn) async {
        final localRows = await txn.query(
          DatabaseService.agendaVisitasTable,
          where: 'id = ?',
          whereArgs: [localId],
          limit: 1,
        );
        final localUuid = localRows.isEmpty
            ? null
            : localRows.first['local_uuid'] as String?;

        await txn.delete(
          DatabaseService.agendaVisitasTable,
          where: 'id = ?',
          whereArgs: [localId],
        );

        await txn.insert(
          DatabaseService.agendaVisitasTable,
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
        DatabaseService.agendaVisitasTable,
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

  Future<Result<void>> replaceAll(List<AgendaVisitaResponse> visitas) async {
    try {
      final db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.delete(DatabaseService.agendaVisitasTable);

        final nowIso = DateTime.now().toUtc().toIso8601String();
        for (final visita in visitas) {
          await txn.insert(
            DatabaseService.agendaVisitasTable,
            _toRow(visita, nowIso, markAsDirty: false),
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
    AgendaVisitaResponse visita,
    String nowIso, {
    required bool markAsDirty,
    String? localUuid,
  }) {
    final serverUpdatedAt = visita.auditoria?.atualizadoEm
        ?.toUtc()
        .toIso8601String();

    return {
      'id': visita.id,
      'local_uuid': localUuid ?? visita.uuidOffline ?? 'av-${visita.id}',
      'data_agendada': visita.dataAgendada.toUtc().toIso8601String(),
      'data_realizada': visita.dataRealizada?.toUtc().toIso8601String(),
      'duracao_prevista': visita.duracaoPrevista,
      'duracao_real': visita.duracaoReal,
      'objetivo': visita.objetivo,
      'observacao': visita.observacao,
      'resultado': visita.resultado,
      'vendedor_id': visita.vendedorId,
      'cliente_id': visita.clienteId,
      'agenda_visita_status_id': visita.agendaVisitaStatusId,
      'agenda_visita_status_nome': visita.agendaVisitaStatusNome,
      'latitude': visita.latitude,
      'longitude': visita.longitude,
      'pedido_gerado': visita.pedidoGerado ? 1 : 0,
      'pedido_id': visita.pedidoId,
      'valor_pedido': visita.valorPedido,
      'sincronizado': visita.sincronizado ? 1 : 0,
      'criado_offline': visita.criadoOffline ? 1 : 0,
      'uuid_offline': visita.uuidOffline,
      'auditoria_criado_em': visita.auditoria?.criadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_atualizado_em': visita.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_indicador_ativo': visita.auditoria?.indicadorAtivo == true
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

  AgendaVisitaResponse _fromRow(Map<String, Object?> row) {
    return AgendaVisitaResponse(
      id: row['id'] as int,
      dataAgendada: _toDateTime(row['data_agendada']) ?? DateTime.now(),
      dataRealizada: _toDateTime(row['data_realizada']),
      duracaoPrevista: row['duracao_prevista'] as int?,
      duracaoReal: row['duracao_real'] as int?,
      objetivo: row['objetivo'] as String?,
      observacao: row['observacao'] as String?,
      resultado: row['resultado'] as String?,
      vendedorId: row['vendedor_id'] as int,
      clienteId: row['cliente_id'] as int?,
      agendaVisitaStatusId: row['agenda_visita_status_id'] as int?,
      agendaVisitaStatusNome: row['agenda_visita_status_nome'] as String?,
      latitude: _toDouble(row['latitude']),
      longitude: _toDouble(row['longitude']),
      pedidoGerado: (row['pedido_gerado'] as int?) == 1,
      pedidoId: row['pedido_id'] as int?,
      valorPedido: _toDouble(row['valor_pedido']),
      sincronizado: (row['sincronizado'] as int?) == 1,
      criadoOffline: (row['criado_offline'] as int?) == 1,
      uuidOffline: row['uuid_offline'] as String?,
      auditoria: Auditoria(
        criadoEm: _toDateTime(row['auditoria_criado_em']),
        atualizadoEm: _toDateTime(row['auditoria_atualizado_em']),
        indicadorAtivo: (row['auditoria_indicador_ativo'] as int?) == 1,
      ),
    );
  }

  DateTime? _toDateTime(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

final agendaVisitaLocalDataSourceProvider =
    Provider<AgendaVisitaLocalDataSource>((ref) {
      final databaseService = ref.watch(databaseProvider);
      return AgendaVisitaLocalDataSource(databaseService: databaseService);
    });
