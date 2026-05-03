import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoLocalDataSource {
  PedidoLocalDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;

  // ─── Pedidos ───

  Future<Result<PedidoResponse>> criarRascunho(
    AdicionarPedidoRequest request, {
    List<AdicionarPedidoItemRequest> itens = const [],
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
  }) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toUtc();
      final localId = -now.microsecondsSinceEpoch;
      final localUuid = 'ped-draft-${now.microsecondsSinceEpoch}';
      final uuidOffline = request.uuidOffline ?? localUuid;
      final nowIso = now.toIso8601String();

      final pedidoRow = {
        'id': localId,
        'local_uuid': localUuid,
        'numero_pedido': null,
        'cliente_id': request.clienteId,
        'vendedor_id': request.vendedorId,
        'pedido_status_tipo_id': request.pedidoStatusTipoId,
        'pedido_status_tipo_nome': pedidoStatusTipoNome,
        'data_pedido': request.dataPedido,
        'data_entrega_prevista': request.dataEntregaPrevista,
        'observacao': request.observacao,
        'subtotal': request.subtotal,
        'percentual_desconto': request.percentualDesconto,
        'valor_desconto': request.valorDesconto,
        'valor_frete': request.valorFrete,
        'valor_total': request.valorTotal,
        'forma_pagamento_id': request.formaPagamentoId,
        'forma_pagamento_nome': formaPagamentoNome,
        'condicao_pagamento_id': request.condicaoPagamentoId,
        'condicao_pagamento_nome': condicaoPagamentoNome,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'sincronizado': 0,
        'criado_offline': 1,
        'is_draft': 1,
        'uuid_offline': uuidOffline,
        'auditoria_criado_em': nowIso,
        'auditoria_atualizado_em': nowIso,
        'auditoria_indicador_ativo': 1,
        'local_updated_at': nowIso,
        'server_updated_at': null,
        'synced_at': null,
        'dirty': 0,
        'deleted': 0,
        'sync_error': null,
        'sync_attempt_count': 0,
      };

      final createdItens = <PedidoItemResponse>[];

      await db.transaction((txn) async {
        await txn.insert(
          DatabaseService.pedidosTable,
          pedidoRow,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        for (final item in itens) {
          final itemLocalId = -(DateTime.now().toUtc().microsecondsSinceEpoch);
          final itemRow = {
            'id': itemLocalId,
            'local_uuid': 'ped-draft-item-${-itemLocalId}',
            'pedido_id': localId,
            'produto_id': item.produtoId,
            'quantidade': item.quantidade,
            'preco_unitario': item.precoUnitario,
            'percentual_desconto': item.percentualDesconto,
            'valor_desconto': item.valorDesconto,
            'valor_total': item.valorTotal,
            'auditoria_criado_em': nowIso,
            'auditoria_atualizado_em': nowIso,
            'auditoria_indicador_ativo': 1,
            'local_updated_at': nowIso,
            'server_updated_at': null,
            'synced_at': null,
            'is_draft': 1,
            'dirty': 0,
            'deleted': 0,
            'sync_error': null,
            'sync_attempt_count': 0,
          };

          await txn.insert(
            DatabaseService.pedidoItensTable,
            itemRow,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          createdItens.add(_itemFromRow(itemRow));
        }
      });

      final pedido = _fromRow(pedidoRow);
      return Result.success(
        PedidoResponse(
          id: pedido.id,
          numeroPedido: pedido.numeroPedido,
          clienteId: pedido.clienteId,
          vendedorId: pedido.vendedorId,
          pedidoStatusTipoId: pedido.pedidoStatusTipoId,
          pedidoStatusTipoNome: pedido.pedidoStatusTipoNome,
          dataPedido: pedido.dataPedido,
          dataEntregaPrevista: pedido.dataEntregaPrevista,
          observacao: pedido.observacao,
          subtotal: pedido.subtotal,
          percentualDesconto: pedido.percentualDesconto,
          valorDesconto: pedido.valorDesconto,
          valorFrete: pedido.valorFrete,
          valorTotal: pedido.valorTotal,
          formaPagamentoId: pedido.formaPagamentoId,
          formaPagamentoNome: pedido.formaPagamentoNome,
          condicaoPagamentoId: pedido.condicaoPagamentoId,
          condicaoPagamentoNome: pedido.condicaoPagamentoNome,
          latitude: pedido.latitude,
          longitude: pedido.longitude,
          sincronizado: pedido.sincronizado,
          criadoOffline: pedido.criadoOffline,
          uuidOffline: pedido.uuidOffline,
          auditoria: pedido.auditoria,
          itens: createdItens,
        ),
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<PedidoResponse>> atualizarRascunho(
    int pedidoId,
    AdicionarPedidoRequest request, {
    List<AdicionarPedidoItemRequest> itens = const [],
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
    bool substituirItens = false,
  }) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toUtc();
      final nowIso = now.toIso8601String();

      PedidoResponse? pedidoAtualizado;

      await db.transaction((txn) async {
        final existingRows = await txn.query(
          DatabaseService.pedidosTable,
          where: 'id = ? AND deleted = 0',
          whereArgs: [pedidoId],
          limit: 1,
        );

        if (existingRows.isEmpty) {
          throw Exception('Pedido rascunho nao encontrado');
        }

        final existingRow = existingRows.first;
        final localUuid = existingRow['local_uuid'] as String?;
        final uuidOffline =
            request.uuidOffline ??
            (existingRow['uuid_offline'] as String?) ??
            localUuid;

        final pedidoRow = {
          'id': pedidoId,
          'local_uuid': localUuid ?? 'ped-draft-$pedidoId',
          'numero_pedido': existingRow['numero_pedido'],
          'cliente_id': request.clienteId,
          'vendedor_id': request.vendedorId,
          'pedido_status_tipo_id': request.pedidoStatusTipoId,
          'pedido_status_tipo_nome': pedidoStatusTipoNome,
          'data_pedido': request.dataPedido,
          'data_entrega_prevista': request.dataEntregaPrevista,
          'observacao': request.observacao,
          'subtotal': request.subtotal,
          'percentual_desconto': request.percentualDesconto,
          'valor_desconto': request.valorDesconto,
          'valor_frete': request.valorFrete,
          'valor_total': request.valorTotal,
          'forma_pagamento_id': request.formaPagamentoId,
          'forma_pagamento_nome': formaPagamentoNome,
          'condicao_pagamento_id': request.condicaoPagamentoId,
          'condicao_pagamento_nome': condicaoPagamentoNome,
          'latitude': request.latitude,
          'longitude': request.longitude,
          'sincronizado': 0,
          'criado_offline': 1,
          'is_draft': 1,
          'uuid_offline': uuidOffline,
          'auditoria_criado_em': existingRow['auditoria_criado_em'] ?? nowIso,
          'auditoria_atualizado_em': nowIso,
          'auditoria_indicador_ativo':
              existingRow['auditoria_indicador_ativo'] ?? 1,
          'local_updated_at': nowIso,
          'server_updated_at': null,
          'synced_at': null,
          'dirty': 0,
          'deleted': 0,
          'sync_error': null,
          'sync_attempt_count': 0,
        };

        await txn.update(
          DatabaseService.pedidosTable,
          pedidoRow,
          where: 'id = ?',
          whereArgs: [pedidoId],
        );

        if (substituirItens) {
          await txn.delete(
            DatabaseService.pedidoItensTable,
            where: 'pedido_id = ?',
            whereArgs: [pedidoId],
          );

          for (final item in itens) {
            final itemLocalId = -(DateTime.now()
                .toUtc()
                .microsecondsSinceEpoch);
            final itemRow = {
              'id': itemLocalId,
              'local_uuid': 'ped-draft-item-${-itemLocalId}',
              'pedido_id': pedidoId,
              'produto_id': item.produtoId,
              'quantidade': item.quantidade,
              'preco_unitario': item.precoUnitario,
              'percentual_desconto': item.percentualDesconto,
              'valor_desconto': item.valorDesconto,
              'valor_total': item.valorTotal,
              'auditoria_criado_em': nowIso,
              'auditoria_atualizado_em': nowIso,
              'auditoria_indicador_ativo': 1,
              'local_updated_at': nowIso,
              'server_updated_at': null,
              'synced_at': null,
              'is_draft': 1,
              'dirty': 0,
              'deleted': 0,
              'sync_error': null,
              'sync_attempt_count': 0,
            };

            await txn.insert(
              DatabaseService.pedidoItensTable,
              itemRow,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }

        final itensRows = await txn.query(
          DatabaseService.pedidoItensTable,
          where: 'pedido_id = ? AND deleted = 0',
          whereArgs: [pedidoId],
        );

        pedidoAtualizado = PedidoResponse(
          id: pedidoId,
          numeroPedido: existingRow['numero_pedido'] as String?,
          clienteId: request.clienteId,
          vendedorId: request.vendedorId,
          pedidoStatusTipoId: request.pedidoStatusTipoId,
          pedidoStatusTipoNome: pedidoStatusTipoNome,
          dataPedido: DateTime.parse(request.dataPedido).toLocal(),
          dataEntregaPrevista: request.dataEntregaPrevista == null
              ? null
              : DateTime.tryParse(request.dataEntregaPrevista!)?.toLocal(),
          observacao: request.observacao,
          subtotal: request.subtotal,
          percentualDesconto: request.percentualDesconto,
          valorDesconto: request.valorDesconto,
          valorFrete: request.valorFrete,
          valorTotal: request.valorTotal,
          formaPagamentoId: request.formaPagamentoId,
          formaPagamentoNome: formaPagamentoNome,
          condicaoPagamentoId: request.condicaoPagamentoId,
          condicaoPagamentoNome: condicaoPagamentoNome,
          latitude: request.latitude,
          longitude: request.longitude,
          sincronizado: false,
          criadoOffline: true,
          uuidOffline: uuidOffline,
          auditoria: Auditoria(
            criadoEm: _toDateTime(existingRow['auditoria_criado_em']),
            atualizadoEm: DateTime.parse(nowIso).toLocal(),
            indicadorAtivo:
                (existingRow['auditoria_indicador_ativo'] as int?) == 1,
          ),
          itens: itensRows.map(_itemFromRow).toList(),
        );
      });

      return Result.success(pedidoAtualizado!);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<PedidoResponse>>> listar({int? vendedorId}) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.pedidosTable,
        where: vendedorId == null
            ? 'deleted = 0'
            : 'deleted = 0 AND vendedor_id = ?',
        whereArgs: vendedorId == null ? null : [vendedorId],
        orderBy: 'data_pedido DESC',
      );

      final pedidos = <PedidoResponse>[];
      for (final row in rows) {
        final pedido = _fromRow(row);
        final itensResult = await listarItensPorPedidoId(pedido.id);
        final itens = itensResult is Success<List<PedidoItemResponse>>
            ? itensResult.value
            : <PedidoItemResponse>[];
        pedidos.add(
          PedidoResponse(
            id: pedido.id,
            numeroPedido: pedido.numeroPedido,
            clienteId: pedido.clienteId,
            vendedorId: pedido.vendedorId,
            pedidoStatusTipoId: pedido.pedidoStatusTipoId,
            pedidoStatusTipoNome: pedido.pedidoStatusTipoNome,
            dataPedido: pedido.dataPedido,
            dataEntregaPrevista: pedido.dataEntregaPrevista,
            observacao: pedido.observacao,
            subtotal: pedido.subtotal,
            percentualDesconto: pedido.percentualDesconto,
            valorDesconto: pedido.valorDesconto,
            valorFrete: pedido.valorFrete,
            valorTotal: pedido.valorTotal,
            formaPagamentoId: pedido.formaPagamentoId,
            formaPagamentoNome: pedido.formaPagamentoNome,
            condicaoPagamentoId: pedido.condicaoPagamentoId,
            condicaoPagamentoNome: pedido.condicaoPagamentoNome,
            latitude: pedido.latitude,
            longitude: pedido.longitude,
            sincronizado: pedido.sincronizado,
            criadoOffline: pedido.criadoOffline,
            uuidOffline: pedido.uuidOffline,
            auditoria: pedido.auditoria,
            itens: itens,
          ),
        );
      }

      return Result.success(pedidos);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<PedidoResponse>> obterPorId(int id) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.pedidosTable,
        where: 'id = ? AND deleted = 0',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return Result.failure(['Pedido nao encontrado no banco local']);
      }

      final pedido = _fromRow(rows.first);
      final itensResult = await listarItensPorPedidoId(pedido.id);
      final itens = itensResult is Success<List<PedidoItemResponse>>
          ? itensResult.value
          : <PedidoItemResponse>[];

      return Result.success(
        PedidoResponse(
          id: pedido.id,
          numeroPedido: pedido.numeroPedido,
          clienteId: pedido.clienteId,
          vendedorId: pedido.vendedorId,
          pedidoStatusTipoId: pedido.pedidoStatusTipoId,
          pedidoStatusTipoNome: pedido.pedidoStatusTipoNome,
          dataPedido: pedido.dataPedido,
          dataEntregaPrevista: pedido.dataEntregaPrevista,
          observacao: pedido.observacao,
          subtotal: pedido.subtotal,
          percentualDesconto: pedido.percentualDesconto,
          valorDesconto: pedido.valorDesconto,
          valorFrete: pedido.valorFrete,
          valorTotal: pedido.valorTotal,
          formaPagamentoId: pedido.formaPagamentoId,
          formaPagamentoNome: pedido.formaPagamentoNome,
          condicaoPagamentoId: pedido.condicaoPagamentoId,
          condicaoPagamentoNome: pedido.condicaoPagamentoNome,
          latitude: pedido.latitude,
          longitude: pedido.longitude,
          sincronizado: pedido.sincronizado,
          criadoOffline: pedido.criadoOffline,
          uuidOffline: pedido.uuidOffline,
          auditoria: pedido.auditoria,
          itens: itens,
        ),
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsert(PedidoResponse pedido) async {
    try {
      final db = await _databaseService.database;
      final nowIso = DateTime.now().toUtc().toIso8601String();

      await db.insert(
        DatabaseService.pedidosTable,
        _toRow(pedido, nowIso, markAsDirty: false),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<PedidoResponse>> upsertOfflineCreate(
    AdicionarPedidoRequest request, {
    required List<AdicionarPedidoItemRequest> itens,
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
  }) async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now().toUtc();
      final localId = -now.microsecondsSinceEpoch;
      final localUuid = 'ped-local-${now.microsecondsSinceEpoch}';
      final uuidOffline = request.uuidOffline ?? localUuid;
      final nowIso = now.toIso8601String();

      final pedidoRow = {
        'id': localId,
        'local_uuid': localUuid,
        'numero_pedido': null,
        'cliente_id': request.clienteId,
        'vendedor_id': request.vendedorId,
        'pedido_status_tipo_id': request.pedidoStatusTipoId,
        'pedido_status_tipo_nome': pedidoStatusTipoNome,
        'data_pedido': request.dataPedido,
        'data_entrega_prevista': request.dataEntregaPrevista,
        'observacao': request.observacao,
        'subtotal': request.subtotal,
        'percentual_desconto': request.percentualDesconto,
        'valor_desconto': request.valorDesconto,
        'valor_frete': request.valorFrete,
        'valor_total': request.valorTotal,
        'forma_pagamento_id': request.formaPagamentoId,
        'forma_pagamento_nome': formaPagamentoNome,
        'condicao_pagamento_id': request.condicaoPagamentoId,
        'condicao_pagamento_nome': condicaoPagamentoNome,
        'latitude': request.latitude,
        'longitude': request.longitude,
        'sincronizado': 0,
        'criado_offline': 1,
        'uuid_offline': uuidOffline,
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

      final createdItens = <PedidoItemResponse>[];

      await db.transaction((txn) async {
        await txn.insert(
          DatabaseService.pedidosTable,
          pedidoRow,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        for (final item in itens) {
          final itemLocalId = -(DateTime.now().toUtc().microsecondsSinceEpoch);
          final itemRow = {
            'id': itemLocalId,
            'local_uuid': 'ped-item-local-${-itemLocalId}',
            'pedido_id': localId,
            'produto_id': item.produtoId,
            'quantidade': item.quantidade,
            'preco_unitario': item.precoUnitario,
            'percentual_desconto': item.percentualDesconto,
            'valor_desconto': item.valorDesconto,
            'valor_total': item.valorTotal,
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

          await txn.insert(
            DatabaseService.pedidoItensTable,
            itemRow,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          createdItens.add(_itemFromRow(itemRow));
        }
      });

      final pedido = _fromRow(pedidoRow);
      return Result.success(
        PedidoResponse(
          id: pedido.id,
          numeroPedido: pedido.numeroPedido,
          clienteId: pedido.clienteId,
          vendedorId: pedido.vendedorId,
          pedidoStatusTipoId: pedido.pedidoStatusTipoId,
          pedidoStatusTipoNome: pedido.pedidoStatusTipoNome,
          dataPedido: pedido.dataPedido,
          dataEntregaPrevista: pedido.dataEntregaPrevista,
          observacao: pedido.observacao,
          subtotal: pedido.subtotal,
          percentualDesconto: pedido.percentualDesconto,
          valorDesconto: pedido.valorDesconto,
          valorFrete: pedido.valorFrete,
          valorTotal: pedido.valorTotal,
          formaPagamentoId: pedido.formaPagamentoId,
          formaPagamentoNome: pedido.formaPagamentoNome,
          condicaoPagamentoId: pedido.condicaoPagamentoId,
          condicaoPagamentoNome: pedido.condicaoPagamentoNome,
          latitude: pedido.latitude,
          longitude: pedido.longitude,
          sincronizado: pedido.sincronizado,
          criadoOffline: pedido.criadoOffline,
          uuidOffline: pedido.uuidOffline,
          auditoria: pedido.auditoria,
          itens: createdItens,
        ),
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> reconcileOfflineCreate({
    required int localId,
    required PedidoResponse remote,
  }) async {
    try {
      final db = await _databaseService.database;
      final nowIso = DateTime.now().toUtc().toIso8601String();

      await db.transaction((txn) async {
        final localRows = await txn.query(
          DatabaseService.pedidosTable,
          where: 'id = ?',
          whereArgs: [localId],
          limit: 1,
        );
        final localUuid = localRows.isEmpty
            ? null
            : localRows.first['local_uuid'] as String?;

        // Delete old local items
        await txn.delete(
          DatabaseService.pedidoItensTable,
          where: 'pedido_id = ?',
          whereArgs: [localId],
        );

        // Delete old local pedido
        await txn.delete(
          DatabaseService.pedidosTable,
          where: 'id = ?',
          whereArgs: [localId],
        );

        // Insert reconciled pedido with server ID
        await txn.insert(
          DatabaseService.pedidosTable,
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
        DatabaseService.pedidosTable,
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

  Future<Result<void>> replaceAll(List<PedidoResponse> pedidos) async {
    try {
      final db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.delete(DatabaseService.pedidoItensTable);
        await txn.delete(DatabaseService.pedidosTable);

        final nowIso = DateTime.now().toUtc().toIso8601String();
        for (final pedido in pedidos) {
          await txn.insert(
            DatabaseService.pedidosTable,
            _toRow(pedido, nowIso, markAsDirty: false),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          for (final item in pedido.itens) {
            await txn.insert(
              DatabaseService.pedidoItensTable,
              _itemToRow(item, nowIso, markAsDirty: false),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
      });

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  // ─── Pedido Itens ───

  Future<Result<List<PedidoItemResponse>>> listarItensPorPedidoId(
    int pedidoId,
  ) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.pedidoItensTable,
        where: 'pedido_id = ? AND deleted = 0',
        whereArgs: [pedidoId],
      );

      final itens = rows.map(_itemFromRow).toList();
      return Result.success(itens);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsertItem(PedidoItemResponse item) async {
    try {
      final db = await _databaseService.database;
      final nowIso = DateTime.now().toUtc().toIso8601String();

      await db.insert(
        DatabaseService.pedidoItensTable,
        _itemToRow(item, nowIso, markAsDirty: false),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  // ─── Converters: Pedido ───

  Map<String, Object?> _toRow(
    PedidoResponse pedido,
    String nowIso, {
    required bool markAsDirty,
    String? localUuid,
  }) {
    return {
      'id': pedido.id,
      'local_uuid': localUuid ?? 'ped-${pedido.id}',
      'numero_pedido': pedido.numeroPedido,
      'cliente_id': pedido.clienteId,
      'vendedor_id': pedido.vendedorId,
      'pedido_status_tipo_id': pedido.pedidoStatusTipoId,
      'pedido_status_tipo_nome': pedido.pedidoStatusTipoNome,
      'data_pedido': pedido.dataPedido.toUtc().toIso8601String(),
      'data_entrega_prevista': pedido.dataEntregaPrevista
          ?.toUtc()
          .toIso8601String(),
      'observacao': pedido.observacao,
      'subtotal': pedido.subtotal,
      'percentual_desconto': pedido.percentualDesconto,
      'valor_desconto': pedido.valorDesconto,
      'valor_frete': pedido.valorFrete,
      'valor_total': pedido.valorTotal,
      'forma_pagamento_id': pedido.formaPagamentoId,
      'forma_pagamento_nome': pedido.formaPagamentoNome,
      'condicao_pagamento_id': pedido.condicaoPagamentoId,
      'condicao_pagamento_nome': pedido.condicaoPagamentoNome,
      'latitude': pedido.latitude,
      'longitude': pedido.longitude,
      'sincronizado': pedido.sincronizado ? 1 : 0,
      'criado_offline': pedido.criadoOffline ? 1 : 0,
      'uuid_offline': pedido.uuidOffline,
      'auditoria_criado_em': pedido.auditoria?.criadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_atualizado_em': pedido.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_indicador_ativo': pedido.auditoria?.indicadorAtivo == true
          ? 1
          : 0,
      'local_updated_at': nowIso,
      'server_updated_at': pedido.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'synced_at': markAsDirty ? null : nowIso,
      'dirty': markAsDirty ? 1 : 0,
      'deleted': 0,
      'sync_error': null,
      'sync_attempt_count': markAsDirty ? 1 : 0,
    };
  }

  PedidoResponse _fromRow(Map<String, Object?> row) {
    return PedidoResponse(
      id: row['id'] as int,
      numeroPedido: row['numero_pedido'] as String?,
      clienteId: (row['cliente_id'] as int?) ?? 0,
      vendedorId: (row['vendedor_id'] as int?) ?? 0,
      pedidoStatusTipoId: row['pedido_status_tipo_id'] as int?,
      pedidoStatusTipoNome: row['pedido_status_tipo_nome'] as String?,
      dataPedido: _toDateTime(row['data_pedido']) ?? DateTime.now(),
      dataEntregaPrevista: _toDateTime(row['data_entrega_prevista']),
      observacao: row['observacao'] as String?,
      subtotal: _toDouble(row['subtotal']) ?? 0,
      percentualDesconto: _toDouble(row['percentual_desconto']),
      valorDesconto: _toDouble(row['valor_desconto']),
      valorFrete: _toDouble(row['valor_frete']),
      valorTotal: _toDouble(row['valor_total']) ?? 0,
      formaPagamentoId: row['forma_pagamento_id'] as int?,
      formaPagamentoNome: row['forma_pagamento_nome'] as String?,
      condicaoPagamentoId: row['condicao_pagamento_id'] as int?,
      condicaoPagamentoNome: row['condicao_pagamento_nome'] as String?,
      latitude: _toDouble(row['latitude']),
      longitude: _toDouble(row['longitude']),
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

  // ─── Converters: Pedido Item ───

  Map<String, Object?> _itemToRow(
    PedidoItemResponse item,
    String nowIso, {
    required bool markAsDirty,
  }) {
    return {
      'id': item.id,
      'local_uuid': 'ped-item-${item.id}',
      'pedido_id': item.pedidoId,
      'produto_id': item.produtoId,
      'quantidade': item.quantidade,
      'preco_unitario': item.precoUnitario,
      'percentual_desconto': item.percentualDesconto,
      'valor_desconto': item.valorDesconto,
      'valor_total': item.valorTotal,
      'auditoria_criado_em': item.auditoria?.criadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_atualizado_em': item.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_indicador_ativo': item.auditoria?.indicadorAtivo == true
          ? 1
          : 0,
      'local_updated_at': nowIso,
      'server_updated_at': item.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'synced_at': markAsDirty ? null : nowIso,
      'dirty': markAsDirty ? 1 : 0,
      'deleted': 0,
      'sync_error': null,
      'sync_attempt_count': markAsDirty ? 1 : 0,
    };
  }

  PedidoItemResponse _itemFromRow(Map<String, Object?> row) {
    return PedidoItemResponse(
      id: row['id'] as int,
      pedidoId: (row['pedido_id'] as int?) ?? 0,
      produtoId: (row['produto_id'] as int?) ?? 0,
      quantidade: _toDouble(row['quantidade']) ?? 0,
      precoUnitario: _toDouble(row['preco_unitario']) ?? 0,
      percentualDesconto: _toDouble(row['percentual_desconto']),
      valorDesconto: _toDouble(row['valor_desconto']),
      valorTotal: _toDouble(row['valor_total']) ?? 0,
      auditoria: Auditoria(
        criadoEm: _toDateTime(row['auditoria_criado_em']),
        atualizadoEm: _toDateTime(row['auditoria_atualizado_em']),
        indicadorAtivo: (row['auditoria_indicador_ativo'] as int?) == 1,
      ),
    );
  }

  // ─── Helpers ───

  DateTime? _toDateTime(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

final pedidoLocalDataSourceProvider = Provider<PedidoLocalDataSource>((ref) {
  final databaseService = ref.watch(databaseProvider);
  return PedidoLocalDataSource(databaseService: databaseService);
});
