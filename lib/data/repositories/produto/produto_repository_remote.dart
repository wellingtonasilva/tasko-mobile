import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository.dart';
import 'package:tasko_mobile/data/service/produto_codigo_barras_service.dart';
import 'package:tasko_mobile/data/service/produto_estoque_service.dart';
import 'package:tasko_mobile/data/service/produto_grupo_service.dart';
import 'package:tasko_mobile/data/service/produto_preco_service.dart';
import 'package:tasko_mobile/data/service/produto_service.dart';
import 'package:tasko_mobile/data/service/produto_unidade_medida_service.dart';
import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_estoque_localizacao_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_preco_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoRepositoryRemote implements ProdutoRepository {
  ProdutoRepositoryRemote({
    required ProdutoService service,
    required ProdutoPrecoService precoService,
    required ProdutoEstoqueService estoqueService,
    required ProdutoCodigoBarrasService codigoBarrasService,
    required ProdutoGrupoService grupoService,
    required ProdutoUnidadeMedidaService unidadeMedidaService,
  }) : _service = service,
       _precoService = precoService,
       _estoqueService = estoqueService,
       _codigoBarrasService = codigoBarrasService,
       _grupoService = grupoService,
       _unidadeMedidaService = unidadeMedidaService;

  final ProdutoService _service;
  final ProdutoPrecoService _precoService;
  final ProdutoEstoqueService _estoqueService;
  final ProdutoCodigoBarrasService _codigoBarrasService;
  final ProdutoGrupoService _grupoService;
  final ProdutoUnidadeMedidaService _unidadeMedidaService;

  @override
  Future<Result<List<ProdutoResponse>>> listar({
    String? termoBusca,
    int? grupoId,
    int? subgrupoId,
  }) async {
    final result = await _service.listar();
    if (result is! Success<List<ProdutoResponse>>) {
      return result;
    }

    var produtos = result.value;

    if (termoBusca != null && termoBusca.trim().isNotEmpty) {
      final search = termoBusca.trim().toLowerCase();
      produtos = produtos.where((produto) {
        final nome = produto.nomeProduto.toLowerCase();
        final codigo = (produto.codigoProduto ?? '').toLowerCase();
        return nome.contains(search) || codigo.contains(search);
      }).toList();
    }

    if (grupoId != null) {
      produtos = produtos
          .where((produto) => produto.grupoId == grupoId)
          .toList();
    }

    if (subgrupoId != null) {
      produtos = produtos
          .where((produto) => produto.subgrupoId == subgrupoId)
          .toList();
    }

    return Result.success(produtos);
  }

  @override
  Future<Result<ProdutoResponse>> obterPorId(int id) {
    return _service.obterPorId(id);
  }

  @override
  Future<Result<List<ProdutoPrecoResponse>>> listarPrecos({int? produtoId}) {
    return _precoService.listar(produtoId: produtoId);
  }

  @override
  Future<Result<List<ProdutoEstoqueLocalizacaoResponse>>> listarEstoques({
    int? produtoId,
  }) {
    return _estoqueService.listar(produtoId: produtoId);
  }

  @override
  Future<Result<List<ProdutoCodigoBarrasResponse>>> listarCodigosBarras({
    int? produtoId,
  }) {
    return _codigoBarrasService.listar(produtoId: produtoId);
  }

  @override
  Future<Result<List<ProdutoGrupoResponse>>> listarGrupos() {
    return _grupoService.listar();
  }

  @override
  Future<Result<List<ProdutoUnidadeMedidaResponse>>> listarUnidadesMedida() {
    return _unidadeMedidaService.listar();
  }
}

final produtoRepositoryRemoteProvider = Provider<ProdutoRepositoryRemote>((
  ref,
) {
  final service = ref.watch(produtoServiceProvider);
  final precoService = ref.watch(produtoPrecoServiceProvider);
  final estoqueService = ref.watch(produtoEstoqueServiceProvider);
  final codigoBarrasService = ref.watch(produtoCodigoBarrasServiceProvider);
  final grupoService = ref.watch(produtoGrupoServiceProvider);
  final unidadeMedidaService = ref.watch(produtoUnidadeMedidaServiceProvider);

  return ProdutoRepositoryRemote(
    service: service,
    precoService: precoService,
    estoqueService: estoqueService,
    codigoBarrasService: codigoBarrasService,
    grupoService: grupoService,
    unidadeMedidaService: unidadeMedidaService,
  );
});
