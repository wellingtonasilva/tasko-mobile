import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/util/command.dart';

class CondicaoPagamentoListarUiState {
  final List<CondicaoPagamentoResponse> condicoesPagamento;
  final Command0 listarCondicoesPagamentoCommand;
  final Command1 excluirCondicaoPagamentoCommand;

  CondicaoPagamentoListarUiState({
    required this.condicoesPagamento,
    required this.listarCondicoesPagamentoCommand,
    required this.excluirCondicaoPagamentoCommand,
  });

  CondicaoPagamentoListarUiState copyWith({
    List<CondicaoPagamentoResponse>? condicoesPagamento,
    Command0? listarCondicoesPagamentoCommand,
    Command1? excluirCondicaoPagamentoCommand,
  }) {
    return CondicaoPagamentoListarUiState(
      condicoesPagamento: condicoesPagamento ?? this.condicoesPagamento,
      listarCondicoesPagamentoCommand:
          listarCondicoesPagamentoCommand ??
          this.listarCondicoesPagamentoCommand,
      excluirCondicaoPagamentoCommand:
          excluirCondicaoPagamentoCommand ??
          this.excluirCondicaoPagamentoCommand,
    );
  }
}
