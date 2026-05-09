import 'package:tasko_mobile/domain/condicao_pagamento/request/atualizar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/util/command.dart';

class CondicaoPagamentoManterUiState {
  CondicaoPagamentoResponse? condicaoPagamento;
  final Command1<CondicaoPagamentoResponse, (int id,)> obterPorIdCommand;
  final Command1<
    CondicaoPagamentoResponse,
    (int id, AtualizarCondicaoPagamentoRequest request)
  >
  atualizarCommand;

  final List<FormaPagamentoResponse> formasPagamento;
  final Command0 listarFormasPagamentoCommand;
  FormaPagamentoResponse? selectedFormaPagamento;

  CondicaoPagamentoManterUiState({
    this.condicaoPagamento,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
    required this.formasPagamento,
    required this.listarFormasPagamentoCommand,
    this.selectedFormaPagamento,
  });

  CondicaoPagamentoManterUiState copyWith({
    CondicaoPagamentoResponse? condicaoPagamento,
    Command1<CondicaoPagamentoResponse, (int id,)>? obterPorIdCommand,
    Command1<
      CondicaoPagamentoResponse,
      (int id, AtualizarCondicaoPagamentoRequest request)
    >?
    atualizarCommand,
    List<FormaPagamentoResponse>? formasPagamento,
    Command0? listarFormasPagamentoCommand,
    FormaPagamentoResponse? selectedFormaPagamento,
  }) {
    return CondicaoPagamentoManterUiState(
      condicaoPagamento: condicaoPagamento ?? this.condicaoPagamento,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
      formasPagamento: formasPagamento ?? this.formasPagamento,
      listarFormasPagamentoCommand:
          listarFormasPagamentoCommand ?? this.listarFormasPagamentoCommand,
      selectedFormaPagamento:
          selectedFormaPagamento ?? this.selectedFormaPagamento,
    );
  }
}
