import 'package:equatable/equatable.dart';

class ProdutoPrecoResponse extends Equatable {
  final int id;
  final int produtoId;
  final int? tabelaPrecoId;
  final String? descricaoTabelaPreco;
  final double? valor;

  const ProdutoPrecoResponse({
    required this.id,
    required this.produtoId,
    this.tabelaPrecoId,
    this.descricaoTabelaPreco,
    this.valor,
  });

  factory ProdutoPrecoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoPrecoResponse(
      id: _toInt(json['id']) ?? 0,
      produtoId: _toInt(json['produtoId']) ?? 0,
      tabelaPrecoId: _toInt(json['tabelaPrecoId']),
      descricaoTabelaPreco: json['descricaoTabelaPreco'] as String?,
      valor: _toDouble(json['valor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produtoId': produtoId,
      'tabelaPrecoId': tabelaPrecoId,
      'descricaoTabelaPreco': descricaoTabelaPreco,
      'valor': valor,
    };
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProdutoPrecoResponse &&
        other.id == id &&
        other.produtoId == produtoId &&
        other.tabelaPrecoId == tabelaPrecoId &&
        other.descricaoTabelaPreco == descricaoTabelaPreco &&
        other.valor == valor;
  }

  @override
  List<Object?> get props => [
    id,
    produtoId,
    tabelaPrecoId,
    descricaoTabelaPreco,
    valor,
  ];
}
