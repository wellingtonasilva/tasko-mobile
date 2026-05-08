class FormaPagamentoResponse {
  final int id;
  final String? descricaoFormaPagamento;

  FormaPagamentoResponse({required this.id, this.descricaoFormaPagamento});

  factory FormaPagamentoResponse.fromJson(Map<String, dynamic> json) {
    return FormaPagamentoResponse(
      id: (json['id'] as int?) ?? 0,
      descricaoFormaPagamento: json['descricaoFormaPagamento'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricaoFormaPagamento': descricaoFormaPagamento};
  }
}
