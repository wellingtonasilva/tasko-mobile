import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/unidade_medida/unidade_medida_repository.dart';
import 'package:tasko_mobile/data/service/produto_unidade_medida_service.dart';
import 'package:tasko_mobile/domain/unidade_medida/request/adicionar_produto_unidade_medida_request.dart';
import 'package:tasko_mobile/domain/unidade_medida/request/atualizar_produto_unidade_medida_request.dart';
import 'package:tasko_mobile/domain/unidade_medida/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/util/result.dart';

class UnidadeMedidaRepositoryRemote implements UnidadeMedidaRepository {
  ProdutoUnidadeMedidaService _service;

  UnidadeMedidaRepositoryRemote({required ProdutoUnidadeMedidaService service})
    : _service = service;

  @override
  Future<Result<ProdutoUnidadeMedidaResponse>> adicionar(
    AdicionarProdutoUnidadeMedidaRequest request,
  ) {
    return _service.adicionar(request);
  }

  @override
  Future<Result<ProdutoUnidadeMedidaResponse>> atualizar(
    int id,
    AtualizarProdutoUnidadeMedidaRequest request,
  ) {
    return _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) {
    return _service.excluir(id);
  }

  @override
  Future<Result<List<ProdutoUnidadeMedidaResponse>>> listar() {
    return _service.listar();
  }

  @override
  Future<Result<ProdutoUnidadeMedidaResponse>> obterPorId(int id) {
    return _service.obterPorId(id);
  }
}

final unidadeMedidaRepositoryRemoteProvider =
    Provider<UnidadeMedidaRepositoryRemote>(
      (ref) => UnidadeMedidaRepositoryRemote(
        service: ref.read(produtoUnidadeMedidaServiceProvider),
      ),
    );
