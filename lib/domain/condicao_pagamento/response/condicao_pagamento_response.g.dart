// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condicao_pagamento_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondicaoPagamentoResponse _$CondicaoPagamentoResponseFromJson(
  Map<String, dynamic> json,
) => CondicaoPagamentoResponse(
  id: (json['id'] as num).toInt(),
  empresaId: (json['empresaId'] as num).toInt(),
  formaPagamentoId: (json['formaPagamentoId'] as num?)?.toInt(),
  descricaoCondicaoPagamento: json['descricaoCondicaoPagamento'] as String?,
  condicaoPagamento: json['condicaoPagamento'] as String?,
);

Map<String, dynamic> _$CondicaoPagamentoResponseToJson(
  CondicaoPagamentoResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'empresaId': instance.empresaId,
  'formaPagamentoId': instance.formaPagamentoId,
  'descricaoCondicaoPagamento': instance.descricaoCondicaoPagamento,
  'condicaoPagamento': instance.condicaoPagamento,
};
