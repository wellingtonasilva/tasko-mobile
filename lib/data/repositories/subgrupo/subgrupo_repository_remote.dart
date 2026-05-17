import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/subgrupo/subgrupo_repository.dart';
import 'package:tasko_mobile/data/service/produto_subgrupo_service.dart';
import 'package:tasko_mobile/domain/subgrupo/request/adicionar_produto_subgrupo2_request.dart';
import 'package:tasko_mobile/domain/subgrupo/request/atualizar_produto_subgrupo_request.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/util/result.dart';

class SubgrupoRepositoryRemote implements ProdutoSubgrupoRepository {
  final ProdutoSubgrupoService _service;

  SubgrupoRepositoryRemote({required ProdutoSubgrupoService service})
    : _service = service;

  @override
  Future<Result<ProdutoSubgrupoResponse>> adicionar(
    AdicionarProdutoSubgrupoRequest request,
  ) {
    return _service.adicionar(request);
  }

  @override
  Future<Result<ProdutoSubgrupoResponse>> atualizar(
    int id,
    AtualizarProdutoSubgrupoRequest request,
  ) {
    return _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) {
    return _service.excluir(id);
  }

  @override
  Future<Result<List<ProdutoSubgrupoResponse>>> listar() {
    return _service.listar();
  }

  @override
  Future<Result<ProdutoSubgrupoResponse>> obterPorId(int id) {
    return _service.obterPorId(id);
  }
}

final subgrupoRepositoryRemoteProvider = Provider<SubgrupoRepositoryRemote>(
  (ref) => SubgrupoRepositoryRemote(
    service: ref.read(produtoSubgrupoServiceProvider),
  ),
);
