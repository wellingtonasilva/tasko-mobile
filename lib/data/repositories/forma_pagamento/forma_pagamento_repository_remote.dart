import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/forma_pagamento/forma_pagamento_repository.dart';
import 'package:tasko_mobile/data/service/forma_pagamento_service.dart';
import 'package:tasko_mobile/domain/forma_pagamento/request/adicionar_forma_pagamento_request.dart';
import 'package:tasko_mobile/domain/forma_pagamento/request/atualizar_forma_pagamento_request.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

class FormaPagamentoRepositoryRemote implements FormaPagamentoRepository {
  final FormaPagamentoService _formaPagamentoService;

  FormaPagamentoRepositoryRemote({
    required FormaPagamentoService formaPagamentoService,
  }) : _formaPagamentoService = formaPagamentoService;

  @override
  Future<Result<FormaPagamentoResponse>> adicionar(
    AdicionarFormaPagamentoRequest request,
  ) async {
    return _formaPagamentoService.adicionar(request);
  }

  @override
  Future<Result<FormaPagamentoResponse>> atualizar(
    int id,
    AtualizarFormaPagamentoRequest request,
  ) async {
    return _formaPagamentoService.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) async {
    return _formaPagamentoService.excluir(id);
  }

  @override
  Future<Result<List<FormaPagamentoResponse>>> listar() async {
    return _formaPagamentoService.listar();
  }

  @override
  Future<Result<FormaPagamentoResponse>> obterPorId(int id) async {
    return _formaPagamentoService.obterPorId(id);
  }

  @override
  Future<Result<List<FormaPagamentoResponse>>>
  listarCondicoesPagamentoAssociadas() {
    return _formaPagamentoService.listar();
  }
}

final formaPagamentoRepositoryRemoteProvider =
    Provider<FormaPagamentoRepositoryRemote>(
      (ref) => FormaPagamentoRepositoryRemote(
        formaPagamentoService: ref.read(formaPagamentoServiceProvider),
      ),
    );
