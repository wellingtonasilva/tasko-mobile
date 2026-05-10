import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/data/database/database_service.dart';
import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoLocalDataSource {
  ProdutoLocalDataSource({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;

  Future<Result<List<ProdutoResponse>>> listar({
    String? termoBusca,
    int? grupoId,
    int? subgrupoId,
  }) async {
    try {
      final db = await _databaseService.database;
      final filters = <String>['deleted = 0'];
      final args = <Object?>[];

      if (termoBusca != null && termoBusca.trim().isNotEmpty) {
        final like = '%${termoBusca.trim()}%';
        filters.add('(nome_produto LIKE ? OR codigo_produto LIKE ?)');
        args.add(like);
        args.add(like);
      }

      if (grupoId != null) {
        filters.add('grupo_id = ?');
        args.add(grupoId);
      }

      if (subgrupoId != null) {
        filters.add('subgrupo_id = ?');
        args.add(subgrupoId);
      }

      final rows = await db.query(
        DatabaseService.produtosTable,
        where: filters.join(' AND '),
        whereArgs: args,
        orderBy: 'nome_produto ASC',
      );

      final produtos = rows.map(_fromRow).toList();
      return Result.success(produtos);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ProdutoResponse>> obterPorId(int id) async {
    try {
      final db = await _databaseService.database;
      final rows = await db.query(
        DatabaseService.produtosTable,
        where: 'id = ? AND deleted = 0',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return Result.failure(['Produto nao encontrado no banco local']);
      }

      return Result.success(_fromRow(rows.first));
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsertMany(List<ProdutoResponse> produtos) async {
    try {
      final db = await _databaseService.database;
      final batch = db.batch();
      final nowIso = DateTime.now().toUtc().toIso8601String();

      for (final produto in produtos) {
        batch.insert(
          DatabaseService.produtosTable,
          _toRow(produto, nowIso),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> upsert(ProdutoResponse produto) async {
    return upsertMany([produto]);
  }

  Future<Result<void>> replaceAll(List<ProdutoResponse> produtos) async {
    try {
      final db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.delete(DatabaseService.produtosTable);

        final nowIso = DateTime.now().toUtc().toIso8601String();
        for (final produto in produtos) {
          await txn.insert(
            DatabaseService.produtosTable,
            _toRow(produto, nowIso),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return Result.success(null);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Map<String, Object?> _toRow(ProdutoResponse produto, String nowIso) {
    return {
      'id': produto.id,
      'empresa_id': produto.empresaId,
      'local_uuid': 'pro-${produto.id}',
      'codigo_produto': produto.codigoProduto,
      'nome_produto': produto.nomeProduto,
      'descricao_produto': produto.descricaoProduto,
      'unidade_medida_id': produto.unidadeMedidaId,
      'unidade_medida_nome': produto.unidadeMedidaNome,
      'grupo_id': produto.grupoId,
      'grupo_nome': produto.grupoNome,
      'subgrupo_id': produto.subgrupoId,
      'subgrupo_nome': produto.subgrupoNome,
      'peso_liquido': produto.pesoLiquido,
      'marca': produto.marca,
      'fornecedor': produto.fornecedor,
      'aliquota_icms': produto.aliquotaIcms,
      'aliquota_ipi': produto.aliquotaIpi,
      'dimensao_altura': produto.dimensaoAltura,
      'dimensao_largura': produto.dimensaoLargura,
      'dimensao_profundidade': produto.dimensaoProfundidade,
      'preco_custo': produto.precoCusto,
      'preco_sugerido': produto.precoSugerido,
      'margem_minima': produto.margemMinima,
      'quantidade_disponivel': produto.quantidadeDisponivel,
      'quantidade_reservada': produto.quantidadeReservada,
      'codigos_barras_json': jsonEncode(
        produto.codigosBarras?.map((e) => e.toJson()).toList(),
      ),
      'auditoria_criado_em': produto.auditoria?.criadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_atualizado_em': produto.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'auditoria_indicador_ativo': produto.auditoria?.indicadorAtivo == true
          ? 1
          : 0,
      'local_updated_at': nowIso,
      'server_updated_at': produto.auditoria?.atualizadoEm
          ?.toUtc()
          .toIso8601String(),
      'synced_at': nowIso,
      'dirty': 0,
      'deleted': 0,
      'sync_error': null,
      'sync_attempt_count': 0,
    };
  }

  ProdutoResponse _fromRow(Map<String, Object?> row) {
    return ProdutoResponse(
      id: row['id'] as int,
      empresaId: row['empresa_id'] as int,
      codigoProduto: row['codigo_produto'] as String?,
      nomeProduto: (row['nome_produto'] as String?) ?? '',
      descricaoProduto: row['descricao_produto'] as String?,
      unidadeMedidaId: row['unidade_medida_id'] as int?,
      unidadeMedidaNome: row['unidade_medida_nome'] as String?,
      grupoId: row['grupo_id'] as int?,
      grupoNome: row['grupo_nome'] as String?,
      subgrupoId: row['subgrupo_id'] as int?,
      subgrupoNome: row['subgrupo_nome'] as String?,
      pesoLiquido: _toDouble(row['peso_liquido']),
      marca: row['marca'] as String?,
      fornecedor: row['fornecedor'] as String?,
      aliquotaIcms: _toDouble(row['aliquota_icms']),
      aliquotaIpi: _toDouble(row['aliquota_ipi']),
      dimensaoAltura: _toDouble(row['dimensao_altura']),
      dimensaoLargura: _toDouble(row['dimensao_largura']),
      dimensaoProfundidade: _toDouble(row['dimensao_profundidade']),
      precoCusto: _toDouble(row['preco_custo']),
      precoSugerido: _toDouble(row['preco_sugerido']),
      margemMinima: _toDouble(row['margem_minima']),
      quantidadeDisponivel: _toDouble(row['quantidade_disponivel']),
      quantidadeReservada: _toDouble(row['quantidade_reservada']),
      codigosBarras: _toCodigosBarras(row['codigos_barras_json']),
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

  List<ProdutoCodigoBarrasResponse> _toCodigosBarras(Object? value) {
    if (value is! String || value.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(ProdutoCodigoBarrasResponse.fromJson)
            .toList();
      }
    } on Exception {
      return const [];
    }

    return const [];
  }
}

final produtoLocalDataSourceProvider = Provider<ProdutoLocalDataSource>((ref) {
  final databaseService = ref.watch(databaseProvider);
  return ProdutoLocalDataSource(databaseService: databaseService);
});
