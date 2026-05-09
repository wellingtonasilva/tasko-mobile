import 'package:tasko_mobile/domain/condicao_pagamento/request/adicionar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/util/command.dart';

class CondicaoPagamentoAdicionarUiState {
  final Command1<CondicaoPagamentoResponse, AdicionarCondicaoPagamentoRequest>
  adicionarCondicaoPagamentoCommand;

  final List<FormaPagamentoResponse> formasPagamento;
  final Command0 listarFormasPagamentoCommand;
  FormaPagamentoResponse? selectedFormaPagamento;

  CondicaoPagamentoAdicionarUiState({
    required this.adicionarCondicaoPagamentoCommand,
    required this.formasPagamento,
    required this.listarFormasPagamentoCommand,
    this.selectedFormaPagamento,
  });

  CondicaoPagamentoAdicionarUiState copyWith({
    Command1<CondicaoPagamentoResponse, AdicionarCondicaoPagamentoRequest>?
    adicionarCondicaoPagamentoCommand,
    List<FormaPagamentoResponse>? formasPagamento,
    Command0? listarFormasPagamentoCommand,
    FormaPagamentoResponse? selectedFormaPagamento,
  }) {
    return CondicaoPagamentoAdicionarUiState(
      adicionarCondicaoPagamentoCommand:
          adicionarCondicaoPagamentoCommand ??
          this.adicionarCondicaoPagamentoCommand,
      formasPagamento: formasPagamento ?? this.formasPagamento,
      listarFormasPagamentoCommand:
          listarFormasPagamentoCommand ?? this.listarFormasPagamentoCommand,
      selectedFormaPagamento:
          selectedFormaPagamento ?? this.selectedFormaPagamento,
    );
  }
}
