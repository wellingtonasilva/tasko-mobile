class ProdutoGrupoResponse {
  final int id;
  final String descricaoGrupo;

  ProdutoGrupoResponse({required this.id, required this.descricaoGrupo});

  factory ProdutoGrupoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoGrupoResponse(
      id: _toInt(json['id']) ?? 0,
      descricaoGrupo: (json['descricaoGrupo'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricaoGrupo': descricaoGrupo};
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
