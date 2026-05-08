// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_condicao_pagamento_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarCondicaoPagamentoRequest _$AtualizarCondicaoPagamentoRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarCondicaoPagamentoRequest(
  id: (json['id'] as num).toInt(),
  empresaId: (json['empresaId'] as num).toInt(),
  descricaoCondicaoPagamento: json['descricaoCondicaoPagamento'] as String,
  condicaoPagamento: json['condicaoPagamento'] as String?,
);

Map<String, dynamic> _$AtualizarCondicaoPagamentoRequestToJson(
  AtualizarCondicaoPagamentoRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'empresaId': instance.empresaId,
  'descricaoCondicaoPagamento': instance.descricaoCondicaoPagamento,
  'condicaoPagamento': instance.condicaoPagamento,
};
