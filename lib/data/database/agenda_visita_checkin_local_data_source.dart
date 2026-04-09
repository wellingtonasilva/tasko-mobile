import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_checkin_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_checkin_response.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaCheckinLocalDataSource {
  AgendaVisitaCheckinLocalDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;

  Future<Result<List<AgendaVisitaCheckinResponse>>> listarPorVisita(
    int agendaVisitaId,
  ) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.agendaVisitaCheckinsTable,
        where: 'agenda_visita_id = ? AND deleted = 0',
        whereArgs: [agendaVisitaId],
        orderBy: 'auditoria_criado_em ASC',
      );

      final checkins = rows.map(_fromRow).toList();
      return Result.success(checkins);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaCheckinResponse>> obterPorId(int id) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.agendaVisitaCheckinsTable,
        where: 'id = ? AND deleted = 0',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return Result.failure(['Checkin nao encontrado no banco local']);
      }

      return Result.success(_fromRow(rows.first));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsert(AgendaVisitaCheckinResponse checkin) async {
    return upsertMany([checkin], markAsDirty: false);
  }

  Future<Result<void>> upsertMany(
    List<AgendaVisitaCheckinResponse> checkins, {
    bool markAsDirty = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final batch = db.batch();
      final nowIso = DateTime.now().toUtc().toIso8601String();

      for (final checkin in checkins) {
        batch.insert(
          DatabaseService.agendaVisitaCheckinsTable,
          _toRow(checkin, nowIso, markAsDirty: markAsDirty),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaCheckinResponse>> upsertOfflineCreate(
    AdicionarAgendaVisitaCheckinRequest request,
  ) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toUtc();
      final localId = -now.microsecondsSinceEpoch;
      final localUuid = 'avc-local-${now.microsecondsSinceEpoch}';

      final row = {
        'id': localId,
        'local_uuid': localUuid,
        'agenda_visita_id': request.agendaVisitaId,
        'vendedor_id': request.vendedorId,
        'cliente_id': request.clienteId,
        'checkin_tipo_id': request.checkinTipoId,
        'checkin_tipo_nome': null,
        'observacao': request.observacao,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'distancia_cliente': request.distanciaCliente,
        'dentro_raio_permitido': request.dentroRaioPermitido == true
            ? 1
            : (request.dentroRaioPermitido == false ? 0 : null),
        'sincronizado': 0,
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
        DatabaseService.agendaVisitaCheckinsTable,
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
    required AgendaVisitaCheckinResponse remote,
  }) async {
    try {
      final db = await _databaseService.database;
      final nowIso = DateTime.now().toUtc().toIso8601String();

      await db.transaction((txn) async {
        final localRows = await txn.query(
          DatabaseService.agendaVisitaCheckinsTable,
          where: 'id = ?',
          whereArgs: [localId],
          limit: 1,
        );
        final localUuid = localRows.isEmpty
            ? null
            : localRows.first['local_uuid'] as String?;

        await txn.delete(
          DatabaseService.agendaVisitaCheckinsTable,
          where: 'id = ?',
          whereArgs: [localId],
        );

        await txn.insert(
          DatabaseService.agendaVisitaCheckinsTable,
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
        DatabaseService.agendaVisitaCheckinsTable,
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

  Future<Result<void>> replaceAllForVisita(
    int agendaVisitaId,
    List<AgendaVisitaCheckinResponse> checkins,
  ) async {
    try {
      final db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.delete(
          DatabaseService.agendaVisitaCheckinsTable,
          where: 'agenda_visita_id = ?',
          whereArgs: [agendaVisitaId],
        );

        final nowIso = DateTime.now().toUtc().toIso8601String();
        for (final checkin in checkins) {
          await txn.insert(
            DatabaseService.agendaVisitaCheckinsTable,
            _toRow(checkin, nowIso, markAsDirty: false),
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
    AgendaVisitaCheckinResponse checkin,
    String nowIso, {
    required bool markAsDirty,
    String? localUuid,
  }) {
    final serverUpdatedAt = checkin.auditoria?.atualizadoEm
        ?.toUtc()
        .toIso8601String();

    return {
      'id': checkin.id,
      'local_uuid': localUuid ?? checkin.uuidOffline ?? 'avc-${checkin.id}',
      'agenda_visita_id': checkin.agendaVisitaId,
      'vendedor_id': checkin.vendedorId,
      'cliente_id': checkin.clienteId,
      'checkin_tipo_id': checkin.checkinTipoId,
      'checkin_tipo_nome': checkin.checkinTipoNome,
      'observacao': checkin.observacao,
      'latitude': checkin.latitude,
      'longitude': checkin.longitude,
      'distancia_cliente': checkin.distanciaCliente,
      'dentro_raio_permitido': checkin.dentroRaioPermitido == true
          ? 1
          : (checkin.dentroRaioPermitido == false ? 0 : null),
      'sincronizado': checkin.sincronizado ? 1 : 0,
      'uuid_offline': checkin.uuidOffline,
      'auditoria_criado_em': checkin.auditoria?.criadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_atualizado_em': checkin.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_indicador_ativo': checkin.auditoria?.indicadorAtivo == true
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

  AgendaVisitaCheckinResponse _fromRow(Map<String, Object?> row) {
    final dentroRaioRaw = row['dentro_raio_permitido'];
    final bool? dentroRaioPermitido = dentroRaioRaw == null
        ? null
        : (dentroRaioRaw as int) == 1;

    return AgendaVisitaCheckinResponse(
      id: row['id'] as int,
      agendaVisitaId: row['agenda_visita_id'] as int,
      vendedorId: row['vendedor_id'] as int,
      clienteId: row['cliente_id'] as int?,
      checkinTipoId: row['checkin_tipo_id'] as int?,
      checkinTipoNome: row['checkin_tipo_nome'] as String?,
      observacao: row['observacao'] as String?,
      latitude: _toDouble(row['latitude']),
      longitude: _toDouble(row['longitude']),
      distanciaCliente: _toDouble(row['distancia_cliente']),
      dentroRaioPermitido: dentroRaioPermitido,
      sincronizado: (row['sincronizado'] as int?) == 1,
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

final agendaVisitaCheckinLocalDataSourceProvider =
    Provider<AgendaVisitaCheckinLocalDataSource>((ref) {
      final databaseService = ref.watch(databaseProvider);
      return AgendaVisitaCheckinLocalDataSource(
        databaseService: databaseService,
      );
    });
