import 'package:equatable/equatable.dart';

class ProdutoCodigoBarrasResponse extends Equatable {
  final int id;
  final int? produtoId;
  final String codigo;
  final String? tipo;

  const ProdutoCodigoBarrasResponse({
    required this.id,
    this.produtoId,
    required this.codigo,
    this.tipo,
  });

  factory ProdutoCodigoBarrasResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoCodigoBarrasResponse(
      id: _toInt(json['id']) ?? 0,
      produtoId: _toInt(json['produtoId']),
      codigo: (json['codigo'] as String?) ?? '',
      tipo: json['tipo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'produtoId': produtoId, 'codigo': codigo, 'tipo': tipo};
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProdutoCodigoBarrasResponse &&
        other.id == id &&
        other.produtoId == produtoId &&
        other.codigo == codigo &&
        other.tipo == tipo;
  }

  @override
  List<Object?> get props => [id, produtoId, codigo, tipo];
}
