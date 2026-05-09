// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_produto_subgrupo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarProdutoSubgrupoRequest _$AtualizarProdutoSubgrupoRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarProdutoSubgrupoRequest(
  id: (json['id'] as num).toInt(),
  empresaId: (json['empresaId'] as num).toInt(),
  descricaoSubgrupo: json['descricaoSubgrupo'] as String,
);

Map<String, dynamic> _$AtualizarProdutoSubgrupoRequestToJson(
  AtualizarProdutoSubgrupoRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'empresaId': instance.empresaId,
  'descricaoSubgrupo': instance.descricaoSubgrupo,
};
