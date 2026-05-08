import 'package:json_annotation/json_annotation.dart';

part 'condicao_pagamento_response.g.dart';

@JsonSerializable()
class CondicaoPagamentoResponse {
  final int id;
  final String? descricaoCondicaoPagamento;

  CondicaoPagamentoResponse({
    required this.id,
    this.descricaoCondicaoPagamento,
  });

  factory CondicaoPagamentoResponse.fromJson(Map<String, dynamic> json) =>
      _$CondicaoPagamentoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CondicaoPagamentoResponseToJson(this);
}
