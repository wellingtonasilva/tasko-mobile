import 'package:tasko_mobile/domain/forma_pagamento/request/adicionar_forma_pagamento_request.dart';
import 'package:tasko_mobile/domain/forma_pagamento/request/atualizar_forma_pagamento_request.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class FormaPagamentoRepository {
  Future<Result<List<FormaPagamentoResponse>>> listar();
  Future<Result<FormaPagamentoResponse>> obterPorId(int id);
  Future<Result<FormaPagamentoResponse>> adicionar(
    AdicionarFormaPagamentoRequest request,
  );
  Future<Result<FormaPagamentoResponse>> atualizar(
    int id,
    AtualizarFormaPagamentoRequest request,
  );
  Future<Result<void>> excluir(int id);
}
