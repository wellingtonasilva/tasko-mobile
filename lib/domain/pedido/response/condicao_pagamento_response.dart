class CondicaoPagamentoResponse {
  final int id;
  final String? nome;

  CondicaoPagamentoResponse({required this.id, this.nome});

  factory CondicaoPagamentoResponse.fromJson(Map<String, dynamic> json) {
    return CondicaoPagamentoResponse(
      id: (json['id'] as int?) ?? 0,
      nome: json['nome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome};
  }
}
