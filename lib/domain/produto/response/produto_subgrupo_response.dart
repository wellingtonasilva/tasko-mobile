class ProdutoSubgrupoResponse {
  final int id;
  final String descricaoSubgrupo;

  ProdutoSubgrupoResponse({required this.id, required this.descricaoSubgrupo});

  factory ProdutoSubgrupoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoSubgrupoResponse(
      id: _toInt(json['id']) ?? 0,
      descricaoSubgrupo: (json['descricaoSubgrupo'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricaoSubgrupo': descricaoSubgrupo};
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
