import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/grupo/grupo_repository.dart';
import 'package:tasko_mobile/data/service/produto_grupo_service.dart';
import 'package:tasko_mobile/domain/grupo/request/adicionar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/request/atualizar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/util/result.dart';

class GrupoRepositoryRemote implements GrupoRepository {
  ProdutoGrupoService _service;

  GrupoRepositoryRemote({required ProdutoGrupoService service})
    : _service = service;

  @override
  Future<Result<ProdutoGrupoResponse>> adicionar(
    AdicionarProdutoGrupoRequest request,
  ) {
    return _service.adicionar(request);
  }

  @override
  Future<Result<ProdutoGrupoResponse>> atualizar(
    int id,
    AtualizarProdutoGrupoRequest request,
  ) {
    return _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) {
    return _service.excluir(id);
  }

  @override
  Future<Result<List<ProdutoGrupoResponse>>> listar() {
    return _service.listar();
  }

  @override
  Future<Result<ProdutoGrupoResponse>> obterPorId(int id) {
    return _service.obterPorId(id);
  }
}

final grupoRepositoryRemoteProvider = Provider<GrupoRepositoryRemote>(
  (ref) =>
      GrupoRepositoryRemote(service: ref.read(produtoGrupoServiceProvider)),
);
