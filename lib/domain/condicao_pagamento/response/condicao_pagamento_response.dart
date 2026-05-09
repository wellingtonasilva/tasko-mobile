import 'package:json_annotation/json_annotation.dart';

part 'condicao_pagamento_response.g.dart';

@JsonSerializable()
class CondicaoPagamentoResponse {
  final int id;
  final int? empresaId;
  final int? formaPagamentoId;
  final String? descricaoCondicaoPagamento;

  CondicaoPagamentoResponse({
    required this.id,
    this.empresaId,
    this.formaPagamentoId,
    this.descricaoCondicaoPagamento,
  });

  factory CondicaoPagamentoResponse.fromJson(Map<String, dynamic> json) =>
      _$CondicaoPagamentoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CondicaoPagamentoResponseToJson(this);
}
