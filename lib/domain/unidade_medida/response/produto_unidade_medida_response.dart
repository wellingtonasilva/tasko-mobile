class ProdutoUnidadeMedidaResponse {
  final int id;
  final String descricaoUnidadeMedida;
  final String? codigo;

  ProdutoUnidadeMedidaResponse({
    required this.id,
    required this.descricaoUnidadeMedida,
    this.codigo,
  });

  factory ProdutoUnidadeMedidaResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoUnidadeMedidaResponse(
      id: _toInt(json['id']) ?? 0,
      descricaoUnidadeMedida: (json['descricaoUnidadeMedida'] as String?) ?? '',
      codigo: json['codigo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricaoUnidadeMedida': descricaoUnidadeMedida,
      'codigo': codigo,
    };
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
