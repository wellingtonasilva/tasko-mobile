class ClienteTabelaPrecoResponse {
  final int id;
  final int clienteId;
  final int? tabelaPrecoId;
  final String? descricaoTabelaPreco;

  ClienteTabelaPrecoResponse({
    required this.id,
    required this.clienteId,
    this.tabelaPrecoId,
    this.descricaoTabelaPreco,
  });

  factory ClienteTabelaPrecoResponse.fromJson(Map<String, dynamic> json) {
    return ClienteTabelaPrecoResponse(
      id: (json['id'] as int?) ?? 0,
      clienteId: (json['clienteId'] as int?) ?? 0,
      tabelaPrecoId: json['tabelaPrecoId'] as int?,
      descricaoTabelaPreco: json['descricaoTabelaPreco'] as String?,
    );
  }
}
