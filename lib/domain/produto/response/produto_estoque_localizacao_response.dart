import 'package:equatable/equatable.dart';

class ProdutoEstoqueLocalizacaoResponse extends Equatable {
  final int id;
  final int produtoId;
  final String? localizacao;
  final double? quantidadeDisponivel;
  final double? quantidadeReservada;

  const ProdutoEstoqueLocalizacaoResponse({
    required this.id,
    required this.produtoId,
    this.localizacao,
    this.quantidadeDisponivel,
    this.quantidadeReservada,
  });

  factory ProdutoEstoqueLocalizacaoResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProdutoEstoqueLocalizacaoResponse(
      id: _toInt(json['id']) ?? 0,
      produtoId: _toInt(json['produtoId']) ?? 0,
      localizacao: json['localizacao'] as String?,
      quantidadeDisponivel: _toDouble(json['quantidadeDisponivel']),
      quantidadeReservada: _toDouble(json['quantidadeReservada']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produtoId': produtoId,
      'localizacao': localizacao,
      'quantidadeDisponivel': quantidadeDisponivel,
      'quantidadeReservada': quantidadeReservada,
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
    return other is ProdutoEstoqueLocalizacaoResponse &&
        other.id == id &&
        other.produtoId == produtoId &&
        other.localizacao == localizacao &&
        other.quantidadeDisponivel == quantidadeDisponivel &&
        other.quantidadeReservada == quantidadeReservada;
  }

  @override
  List<Object?> get props => [
    id,
    produtoId,
    localizacao,
    quantidadeDisponivel,
    quantidadeReservada,
  ];
}
