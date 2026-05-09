import 'package:tasko_mobile/domain/unidade_medida/request/adicionar_produto_unidade_medida_request.dart';
import 'package:tasko_mobile/domain/unidade_medida/request/atualizar_produto_unidade_medida_request.dart';
import 'package:tasko_mobile/domain/unidade_medida/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class UnidadeMedidaRepository {
  Future<Result<List<ProdutoUnidadeMedidaResponse>>> listar();
  Future<Result<ProdutoUnidadeMedidaResponse>> obterPorId(int id);
  Future<Result<ProdutoUnidadeMedidaResponse>> adicionar(
    AdicionarProdutoUnidadeMedidaRequest request,
  );
  Future<Result<ProdutoUnidadeMedidaResponse>> atualizar(
    int id,
    AtualizarProdutoUnidadeMedidaRequest request,
  );
  Future<Result<void>> excluir(int id);
}
