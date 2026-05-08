import 'package:json_annotation/json_annotation.dart';

part 'atualizar_forma_pagamento_request.g.dart';

@JsonSerializable()
class AtualizarFormaPagamentoRequest {
  final int id;
  final int empresaId;
  final String descricaoFormaPagamento;

  AtualizarFormaPagamentoRequest({
    required this.id,
    required this.empresaId,
    required this.descricaoFormaPagamento,
  });

  factory AtualizarFormaPagamentoRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarFormaPagamentoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AtualizarFormaPagamentoRequestToJson(this);
}
