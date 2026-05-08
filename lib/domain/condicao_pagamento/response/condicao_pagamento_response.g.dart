// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condicao_pagamento_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondicaoPagamentoResponse _$CondicaoPagamentoResponseFromJson(
  Map<String, dynamic> json,
) => CondicaoPagamentoResponse(
  id: (json['id'] as num).toInt(),
  descricaoCondicaoPagamento: json['descricaoCondicaoPagamento'] as String?,
);

Map<String, dynamic> _$CondicaoPagamentoResponseToJson(
  CondicaoPagamentoResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'descricaoCondicaoPagamento': instance.descricaoCondicaoPagamento,
};
