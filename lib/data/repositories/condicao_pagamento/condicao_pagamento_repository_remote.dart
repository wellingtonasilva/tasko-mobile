import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/condicao_pagamento/condicao_pagamento_repository.dart';
import 'package:tasko_mobile/data/service/condicao_pagamento_service.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/request/adicionar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/request/atualizar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

class CondicaoPagamentoRepositoryRemote implements CondicaoPagamentoRepository {
  final CondicaoPagamentoService _service;

  CondicaoPagamentoRepositoryRemote({required CondicaoPagamentoService service})
    : _service = service;

  @override
  Future<Result<CondicaoPagamentoResponse>> adicionar(
    AdicionarCondicaoPagamentoRequest request,
  ) {
    return _service.adicionar(request);
  }

  @override
  Future<Result<CondicaoPagamentoResponse>> atualizar(
    int id,
    AtualizarCondicaoPagamentoRequest request,
  ) {
    return _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) {
    return _service.excluir(id);
  }

  @override
  Future<Result<List<CondicaoPagamentoResponse>>> listar() {
    return _service.listar();
  }

  @override
  Future<Result<CondicaoPagamentoResponse>> obterPorId(int id) {
    return _service.obterPorId(id);
  }
}

final condicaoPagamentoRepositoryRemoteProvider =
    Provider<CondicaoPagamentoRepository>(
      (ref) => CondicaoPagamentoRepositoryRemote(
        service: ref.watch(condicaoPagamentoServiceProvider),
      ),
    );
