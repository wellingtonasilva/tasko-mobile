import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pedido_criar_pagamento_ui_state.dart';

class PedidoCriarPagamentoViewModel
    extends Notifier<PedidoCriarPagamentoUiState> {
  @override
  PedidoCriarPagamentoUiState build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}

final pedidoCriarPagamentoViewModelProvider =
    NotifierProvider<
      PedidoCriarPagamentoViewModel,
      PedidoCriarPagamentoUiState
    >(() => PedidoCriarPagamentoViewModel());
