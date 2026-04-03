class ProdutoGrupoResponse {
  final int id;
  final String nome;

  ProdutoGrupoResponse({required this.id, required this.nome});

  factory ProdutoGrupoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoGrupoResponse(
      id: _toInt(json['id']) ?? 0,
      nome: (json['nome'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome};
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
