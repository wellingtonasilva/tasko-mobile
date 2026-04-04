class PedidoStatusTipoResponse {
  final int id;
  final String? nome;

  PedidoStatusTipoResponse({required this.id, this.nome});

  factory PedidoStatusTipoResponse.fromJson(Map<String, dynamic> json) {
    return PedidoStatusTipoResponse(
      id: (json['id'] as int?) ?? 0,
      nome: json['nome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome};
  }
}
