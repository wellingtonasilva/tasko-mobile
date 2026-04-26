// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_perfil_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioPerfilResponse _$UsuarioPerfilResponseFromJson(
  Map<String, dynamic> json,
) => UsuarioPerfilResponse(
  id: (json['id'] as num).toInt(),
  perfilTipo: json['perfilTipo'] as String,
);

Map<String, dynamic> _$UsuarioPerfilResponseToJson(
  UsuarioPerfilResponse instance,
) => <String, dynamic>{'id': instance.id, 'perfilTipo': instance.perfilTipo};
