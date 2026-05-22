class PedidoCriarPagamentoUiState {
  final String? formaPagamentoNome;
  final String? condicaoPagamentoNome;

  const PedidoCriarPagamentoUiState({
    this.formaPagamentoNome,
    this.condicaoPagamentoNome,
  });

  PedidoCriarPagamentoUiState copyWith({
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    bool clearFormaPagamento = false,
    bool clearCondicaoPagamento = false,
  }) {
    return PedidoCriarPagamentoUiState(
      formaPagamentoNome: clearFormaPagamento
          ? null
          : formaPagamentoNome ?? this.formaPagamentoNome,
      condicaoPagamentoNome: clearCondicaoPagamento
          ? null
          : condicaoPagamentoNome ?? this.condicaoPagamentoNome,
    );
  }
}
