// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_usuario_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarUsuarioRequest _$AtualizarUsuarioRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarUsuarioRequest(
  id: (json['id'] as num).toInt(),
  nomeUsuario: json['nomeUsuario'] as String,
  senha: json['senha'] as String,
  vendedorId: (json['vendedorId'] as num).toInt(),
);

Map<String, dynamic> _$AtualizarUsuarioRequestToJson(
  AtualizarUsuarioRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'nomeUsuario': instance.nomeUsuario,
  'senha': instance.senha,
  'vendedorId': instance.vendedorId,
};
