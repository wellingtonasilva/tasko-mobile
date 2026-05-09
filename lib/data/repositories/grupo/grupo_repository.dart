import 'package:tasko_mobile/domain/grupo/request/adicionar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/request/atualizar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class GrupoRepository {
  Future<Result<List<ProdutoGrupoResponse>>> listar();
  Future<Result<ProdutoGrupoResponse>> obterPorId(int id);
  Future<Result<ProdutoGrupoResponse>> adicionar(
    AdicionarProdutoGrupoRequest request,
  );
  Future<Result<ProdutoGrupoResponse>> atualizar(
    int id,
    AtualizarProdutoGrupoRequest request,
  );
  Future<Result<void>> excluir(int id);
}
