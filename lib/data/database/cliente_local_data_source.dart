import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteLocalDataSource {
  ClienteLocalDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;

  Future<Result<List<ClienteResponse>>> listar({int? vendedorId}) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.clientesTable,
        where: vendedorId == null
            ? 'deleted = 0'
            : 'deleted = 0 AND vendedor_id = ?',
        whereArgs: vendedorId == null ? null : [vendedorId],
        orderBy: 'razao_social ASC',
      );

      final clientes = rows.map(_fromRow).toList();
      return Result.success(clientes);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ClienteResponse>> obterPorId(int id) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.clientesTable,
        where: 'id = ? AND deleted = 0',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return Result.failure(['Cliente nao encontrado no banco local']);
      }

      return Result.success(_fromRow(rows.first));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsert(ClienteResponse cliente) {
    return upsertMany([cliente], markAsDirty: false);
  }

  Future<Result<void>> upsertMany(
    List<ClienteResponse> clientes, {
    required bool markAsDirty,
  }) async {
    try {
      final db = await _databaseService.database;
      final batch = db.batch();
      final nowIso = DateTime.now().toUtc().toIso8601String();

      for (final cliente in clientes) {
        batch.insert(
          DatabaseService.clientesTable,
          _toRow(cliente, nowIso, markAsDirty: markAsDirty),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ClienteResponse>> upsertOfflineCreate(
    AdicionarClienteRequest request,
  ) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toUtc();
      final localId = -now.microsecondsSinceEpoch;
      final localUuid = 'cli-local-${now.microsecondsSinceEpoch}';
      final nowIso = now.toIso8601String();

      final row = {
        'id': localId,
        'local_uuid': localUuid,
        'vendedor_id': request.vendedorId,
        'codigo_cliente': request.codigoCliente,
        'razao_social': request.razaoSocial,
        'nome_fantasia': request.nomeFantasia,
        'cnpj_cpf': request.cnpjCpf,
        'inscricao_estadual': request.inscricaoEstadual,
        'tipo': request.tipo,
        'segmento': request.segmento,
        'categoria': request.categoria,
        'cep': request.cep,
        'logradouro': request.logradouro,
        'complemento': request.complemento,
        'bairro': request.bairro,
        'cidade': request.cidade,
        'estado': request.estado,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'limite_credito': request.limiteCredito,
        'prazo_pagamento': request.prazoPagamento,
        'data_ultimo_pedido': null,
        'valor_ultima_compra': null,
        'bloqueado': request.bloqueado == true ? 1 : 0,
        'motivo_bloqueio': request.motivoBloqueio,
        'auditoria_criado_em': nowIso,
        'auditoria_atualizado_em': nowIso,
        'auditoria_indicador_ativo': 1,
        'local_updated_at': nowIso,
        'server_updated_at': null,
        'synced_at': null,
        'dirty': 1,
        'deleted': 0,
        'sync_error': null,
        'sync_attempt_count': 0,
      };

      await db.insert(
        DatabaseService.clientesTable,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Result.success(_fromRow(row));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ClienteResponse>> upsertOfflineUpdate(
    AtualizarClienteRequest request,
  ) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final merged = ClienteResponse(
        id: request.id,
        vendedorId: request.vendedorId,
        codigoCliente: request.codigoCliente,
        razaoSocial: request.razaoSocial,
        nomeFantasia: request.nomeFantasia,
        cnpjCpf: request.cnpjCpf,
        inscricaoEstadual: request.inscricaoEstadual,
        tipo: request.tipo,
        segmento: request.segmento,
        categoria: request.categoria,
        cep: request.cep,
        logradouro: request.logradouro,
        complemento: request.complemento,
        bairro: request.bairro,
        cidade: request.cidade,
        estado: request.estado,
        latitude: request.latitude,
        longitude: request.longitude,
        limiteCredito: request.limiteCredito,
        prazoPagamento: request.prazoPagamento,
        dataUltimoPedido: null,
        valorUltimaCompra: null,
        bloqueado: request.bloqueado ?? false,
        motivoBloqueio: request.motivoBloqueio,
        auditoria: Auditoria(
          criadoEm: DateTime.now().toUtc(),
          atualizadoEm: DateTime.now().toUtc(),
          indicadorAtivo: true,
        ),
      );

      final db = await _databaseService.database;
      await db.insert(
        DatabaseService.clientesTable,
        _toRow(merged, now, markAsDirty: true),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Result.success(merged);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> reconcileOfflineCreate({
    required int localId,
    required ClienteResponse remote,
  }) async {
    try {
      final db = await _databaseService.database;
      final nowIso = DateTime.now().toUtc().toIso8601String();

      await db.transaction((txn) async {
        final localRows = await txn.query(
          DatabaseService.clientesTable,
          where: 'id = ?',
          whereArgs: [localId],
          limit: 1,
        );
        final localUuid = localRows.isEmpty
            ? null
            : localRows.first['local_uuid'] as String?;

        await txn.delete(
          DatabaseService.clientesTable,
          where: 'id = ?',
          whereArgs: [localId],
        );

        await txn.insert(
          DatabaseService.clientesTable,
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
        DatabaseService.clientesTable,
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

  Future<Result<void>> replaceAll(List<ClienteResponse> clientes) async {
    try {
      final db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.delete(DatabaseService.clientesTable);

        final nowIso = DateTime.now().toUtc().toIso8601String();
        for (final cliente in clientes) {
          await txn.insert(
            DatabaseService.clientesTable,
            _toRow(cliente, nowIso, markAsDirty: false),
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
    ClienteResponse cliente,
    String nowIso, {
    required bool markAsDirty,
    String? localUuid,
  }) {
    return {
      'id': cliente.id,
      'local_uuid': localUuid ?? 'cli-${cliente.id}',
      'vendedor_id': cliente.vendedorId,
      'codigo_cliente': cliente.codigoCliente,
      'razao_social': cliente.razaoSocial,
      'nome_fantasia': cliente.nomeFantasia,
      'cnpj_cpf': cliente.cnpjCpf,
      'inscricao_estadual': cliente.inscricaoEstadual,
      'tipo': cliente.tipo,
      'segmento': cliente.segmento,
      'categoria': cliente.categoria,
      'cep': cliente.cep,
      'logradouro': cliente.logradouro,
      'complemento': cliente.complemento,
      'bairro': cliente.bairro,
      'cidade': cliente.cidade,
      'estado': cliente.estado,
      'latitude': cliente.latitude,
      'longitude': cliente.longitude,
      'limite_credito': cliente.limiteCredito,
      'prazo_pagamento': cliente.prazoPagamento,
      'data_ultimo_pedido': cliente.dataUltimoPedido?.toUtc().toIso8601String(),
      'valor_ultima_compra': cliente.valorUltimaCompra,
      'bloqueado': cliente.bloqueado ? 1 : 0,
      'motivo_bloqueio': cliente.motivoBloqueio,
      'auditoria_criado_em': cliente.auditoria?.criadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_atualizado_em': cliente.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_indicador_ativo': cliente.auditoria?.indicadorAtivo == true
          ? 1
          : 0,
      'local_updated_at': nowIso,
      'server_updated_at': cliente.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'synced_at': markAsDirty ? null : nowIso,
      'dirty': markAsDirty ? 1 : 0,
      'deleted': 0,
      'sync_error': null,
      'sync_attempt_count': markAsDirty ? 1 : 0,
    };
  }

  ClienteResponse _fromRow(Map<String, Object?> row) {
    return ClienteResponse(
      id: row['id'] as int,
      vendedorId: row['vendedor_id'] as int?,
      codigoCliente: row['codigo_cliente'] as String?,
      razaoSocial: (row['razao_social'] as String?) ?? '',
      nomeFantasia: row['nome_fantasia'] as String?,
      cnpjCpf: row['cnpj_cpf'] as String?,
      inscricaoEstadual: row['inscricao_estadual'] as String?,
      tipo: row['tipo'] as String?,
      segmento: row['segmento'] as String?,
      categoria: row['categoria'] as String?,
      cep: row['cep'] as String?,
      logradouro: row['logradouro'] as String?,
      complemento: row['complemento'] as String?,
      bairro: row['bairro'] as String?,
      cidade: row['cidade'] as String?,
      estado: row['estado'] as String?,
      latitude: _toDouble(row['latitude']),
      longitude: _toDouble(row['longitude']),
      limiteCredito: _toDouble(row['limite_credito']),
      prazoPagamento: row['prazo_pagamento'] as int?,
      dataUltimoPedido: _toDateTime(row['data_ultimo_pedido']),
      valorUltimaCompra: _toDouble(row['valor_ultima_compra']),
      bloqueado: (row['bloqueado'] as int?) == 1,
      motivoBloqueio: row['motivo_bloqueio'] as String?,
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
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

final clienteLocalDataSourceProvider = Provider<ClienteLocalDataSource>((ref) {
  final databaseService = ref.watch(databaseProvider);
  return ClienteLocalDataSource(databaseService: databaseService);
});
