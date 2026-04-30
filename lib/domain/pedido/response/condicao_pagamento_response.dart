class CondicaoPagamentoResponse {
  final int id;
  final String? descricaoCondicaoPagamento;

  CondicaoPagamentoResponse({
    required this.id,
    this.descricaoCondicaoPagamento,
  });

  factory CondicaoPagamentoResponse.fromJson(Map<String, dynamic> json) {
    return CondicaoPagamentoResponse(
      id: (json['id'] as int?) ?? 0,
      descricaoCondicaoPagamento: json['descricaoCondicaoPagamento'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricaoCondicaoPagamento': descricaoCondicaoPagamento};
  }
}
