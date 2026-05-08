import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/util/command.dart';

class FormaPagamentoListarUiState {
  final List<FormaPagamentoResponse> formasPagamento;
  final Command0 listarFormasPagamentoCommand;
  final Command1 excluirFormaPagamentoCommand;

  FormaPagamentoListarUiState({
    required this.formasPagamento,
    required this.listarFormasPagamentoCommand,
    required this.excluirFormaPagamentoCommand,
  });

  FormaPagamentoListarUiState copyWith({
    List<FormaPagamentoResponse>? formasPagamento,
    Command0? listarFormasPagamentoCommand,
    Command1? excluirFormaPagamentoCommand,
  }) {
    return FormaPagamentoListarUiState(
      formasPagamento: formasPagamento ?? this.formasPagamento,
      listarFormasPagamentoCommand:
          listarFormasPagamentoCommand ?? this.listarFormasPagamentoCommand,
      excluirFormaPagamentoCommand:
          excluirFormaPagamentoCommand ?? this.excluirFormaPagamentoCommand,
    );
  }
}
