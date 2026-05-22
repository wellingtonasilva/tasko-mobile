import 'package:tasko_mobile/domain/condicao_pagamento/request/adicionar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/request/atualizar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class CondicaoPagamentoRepository {
  Future<Result<List<CondicaoPagamentoResponse>>> listar();
  Future<Result<List<CondicaoPagamentoResponse>>> listarByFormaPagamento(
    int formaPagamentoId,
  );
  Future<Result<CondicaoPagamentoResponse>> obterPorId(int id);
  Future<Result<CondicaoPagamentoResponse>> adicionar(
    AdicionarCondicaoPagamentoRequest request,
  );
  Future<Result<CondicaoPagamentoResponse>> atualizar(
    int id,
    AtualizarCondicaoPagamentoRequest request,
  );
  Future<Result<void>> excluir(int id);
}
