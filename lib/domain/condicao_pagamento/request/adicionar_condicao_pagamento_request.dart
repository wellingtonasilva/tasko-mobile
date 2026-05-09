import 'package:json_annotation/json_annotation.dart';

part 'adicionar_condicao_pagamento_request.g.dart';

@JsonSerializable()
class AdicionarCondicaoPagamentoRequest {
  final int? formaPagamentoId;
  final String descricaoCondicaoPagamento;
  final String? condicaoPagamento;

  AdicionarCondicaoPagamentoRequest({
    this.formaPagamentoId,
    required this.descricaoCondicaoPagamento,
    this.condicaoPagamento,
  });

  factory AdicionarCondicaoPagamentoRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AdicionarCondicaoPagamentoRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AdicionarCondicaoPagamentoRequestToJson(this);
}
