class FormaPagamentoResponse {
  final int id;
  final String? nome;

  FormaPagamentoResponse({required this.id, this.nome});

  factory FormaPagamentoResponse.fromJson(Map<String, dynamic> json) {
    return FormaPagamentoResponse(
      id: (json['id'] as int?) ?? 0,
      nome: json['nome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome};
  }
}
