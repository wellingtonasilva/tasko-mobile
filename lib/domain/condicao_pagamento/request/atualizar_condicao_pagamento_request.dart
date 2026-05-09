import 'package:json_annotation/json_annotation.dart';

part 'atualizar_condicao_pagamento_request.g.dart';

@JsonSerializable()
class AtualizarCondicaoPagamentoRequest {
  final int id;
  final int empresaId;
  final int? formaPagamentoId;
  final String descricaoCondicaoPagamento;
  final String? condicaoPagamento;

  AtualizarCondicaoPagamentoRequest({
    required this.id,
    required this.empresaId,
    this.formaPagamentoId,
    required this.descricaoCondicaoPagamento,
    this.condicaoPagamento,
  });

  factory AtualizarCondicaoPagamentoRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AtualizarCondicaoPagamentoRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AtualizarCondicaoPagamentoRequestToJson(this);
}
