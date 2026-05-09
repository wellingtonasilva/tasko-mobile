class ProdutoUnidadeMedidaResponse {
  final int id;
  final String nome;
  final String? sigla;

  ProdutoUnidadeMedidaResponse({
    required this.id,
    required this.nome,
    this.sigla,
  });

  factory ProdutoUnidadeMedidaResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoUnidadeMedidaResponse(
      id: _toInt(json['id']) ?? 0,
      nome: (json['nome'] as String?) ?? '',
      sigla: json['sigla'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'sigla': sigla};
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
