// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adicionar_condicao_pagamento_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdicionarCondicaoPagamentoRequest _$AdicionarCondicaoPagamentoRequestFromJson(
  Map<String, dynamic> json,
) => AdicionarCondicaoPagamentoRequest(
  descricaoCondicaoPagamento: json['descricaoCondicaoPagamento'] as String,
  condicaoPagamento: json['condicaoPagamento'] as String?,
);

Map<String, dynamic> _$AdicionarCondicaoPagamentoRequestToJson(
  AdicionarCondicaoPagamentoRequest instance,
) => <String, dynamic>{
  'descricaoCondicaoPagamento': instance.descricaoCondicaoPagamento,
  'condicaoPagamento': instance.condicaoPagamento,
};
