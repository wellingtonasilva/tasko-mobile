import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condicao_pagamento_response.g.dart';

@JsonSerializable()
class CondicaoPagamentoResponse extends Equatable {
  final int id;
  final int? empresaId;
  final int? formaPagamentoId;
  final String? descricaoCondicaoPagamento;
  final String? condicaoPagamento;

  const CondicaoPagamentoResponse({
    required this.id,
    this.empresaId,
    this.formaPagamentoId,
    this.descricaoCondicaoPagamento,
    this.condicaoPagamento,
  });

  factory CondicaoPagamentoResponse.fromJson(Map<String, dynamic> json) =>
      _$CondicaoPagamentoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CondicaoPagamentoResponseToJson(this);

  @override
  List<Object?> get props => [
    id,
    empresaId,
    formaPagamentoId,
    descricaoCondicaoPagamento,
    condicaoPagamento,
  ];
}
