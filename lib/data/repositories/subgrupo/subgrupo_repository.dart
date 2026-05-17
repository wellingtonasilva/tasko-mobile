import 'package:tasko_mobile/domain/subgrupo/request/adicionar_produto_subgrupo2_request.dart';
import 'package:tasko_mobile/domain/subgrupo/request/atualizar_produto_subgrupo_request.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class ProdutoSubgrupoRepository {
  Future<Result<List<ProdutoSubgrupoResponse>>> listar();
  Future<Result<ProdutoSubgrupoResponse>> obterPorId(int id);
  Future<Result<ProdutoSubgrupoResponse>> adicionar(
    AdicionarProdutoSubgrupoRequest request,
  );
  Future<Result<ProdutoSubgrupoResponse>> atualizar(
    int id,
    AtualizarProdutoSubgrupoRequest request,
  );
  Future<Result<void>> excluir(int id);
}
