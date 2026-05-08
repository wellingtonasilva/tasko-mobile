import 'package:json_annotation/json_annotation.dart';

part 'adicionar_forma_pagamento_request.g.dart';

@JsonSerializable()
class AdicionarFormaPagamentoRequest {
  final String descricaoFormaPagamento;

  AdicionarFormaPagamentoRequest({required this.descricaoFormaPagamento});

  factory AdicionarFormaPagamentoRequest.fromJson(Map<String, dynamic> json) =>
      _$AdicionarFormaPagamentoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AdicionarFormaPagamentoRequestToJson(this);
}
