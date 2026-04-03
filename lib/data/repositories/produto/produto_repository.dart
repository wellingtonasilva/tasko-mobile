import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_estoque_localizacao_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_preco_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class ProdutoRepository {
  Future<Result<List<ProdutoResponse>>> listar({
    String? termoBusca,
    int? grupoId,
    int? subgrupoId,
  });

  Future<Result<ProdutoResponse>> obterPorId(int id);

  Future<Result<List<ProdutoPrecoResponse>>> listarPrecos({int? produtoId});

  Future<Result<List<ProdutoEstoqueLocalizacaoResponse>>> listarEstoques({
    int? produtoId,
  });

  Future<Result<List<ProdutoCodigoBarrasResponse>>> listarCodigosBarras({
    int? produtoId,
  });

  Future<Result<List<ProdutoGrupoResponse>>> listarGrupos();

  Future<Result<List<ProdutoUnidadeMedidaResponse>>> listarUnidadesMedida();
}
