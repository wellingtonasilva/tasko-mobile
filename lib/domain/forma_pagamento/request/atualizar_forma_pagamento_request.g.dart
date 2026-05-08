// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_forma_pagamento_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarFormaPagamentoRequest _$AtualizarFormaPagamentoRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarFormaPagamentoRequest(
  id: (json['id'] as num).toInt(),
  empresaId: (json['empresaId'] as num).toInt(),
  descricaoFormaPagamento: json['descricaoFormaPagamento'] as String,
);

Map<String, dynamic> _$AtualizarFormaPagamentoRequestToJson(
  AtualizarFormaPagamentoRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'empresaId': instance.empresaId,
  'descricaoFormaPagamento': instance.descricaoFormaPagamento,
};
