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
  }) {
    return PedidoCriarPagamentoUiState(
      formaPagamentoNome: formaPagamentoNome ?? this.formaPagamentoNome,
      condicaoPagamentoNome:
          condicaoPagamentoNome ?? this.condicaoPagamentoNome,
    );
  }
}
