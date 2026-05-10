// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_produto_grupo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarProdutoGrupoRequest _$AtualizarProdutoGrupoRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarProdutoGrupoRequest(
  id: (json['id'] as num).toInt(),
  descricaoGrupo: json['descricaoGrupo'] as String,
);

Map<String, dynamic> _$AtualizarProdutoGrupoRequestToJson(
  AtualizarProdutoGrupoRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'descricaoGrupo': instance.descricaoGrupo,
};
