import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pedido_criar_pagamento_ui_state.dart';

class PedidoCriarPagamentoViewModel
    extends Notifier<PedidoCriarPagamentoUiState> {
  @override
  PedidoCriarPagamentoUiState build() {
    return const PedidoCriarPagamentoUiState();
  }

  void setFormaPagamento(String nome) {
    state = state.copyWith(formaPagamentoNome: nome);
  }

  void setCondicaoPagamento(String nome) {
    state = state.copyWith(condicaoPagamentoNome: nome);
  }

  void preencherPagamento(String? formaNome, String? condicaoNome) {
    state = state.copyWith(
      formaPagamentoNome: formaNome,
      condicaoPagamentoNome: condicaoNome,
    );
  }
}

final pedidoCriarPagamentoViewModelProvider =
    NotifierProvider<
      PedidoCriarPagamentoViewModel,
      PedidoCriarPagamentoUiState
    >(() => PedidoCriarPagamentoViewModel());
