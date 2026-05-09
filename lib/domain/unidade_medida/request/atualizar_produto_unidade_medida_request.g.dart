// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_produto_unidade_medida_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarProdutoUnidadeMedidaRequest
_$AtualizarProdutoUnidadeMedidaRequestFromJson(Map<String, dynamic> json) =>
    AtualizarProdutoUnidadeMedidaRequest(
      id: (json['id'] as num).toInt(),
      descricaoUnidadeMedida: json['descricaoUnidadeMedida'] as String,
    );

Map<String, dynamic> _$AtualizarProdutoUnidadeMedidaRequestToJson(
  AtualizarProdutoUnidadeMedidaRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'descricaoUnidadeMedida': instance.descricaoUnidadeMedida,
};
