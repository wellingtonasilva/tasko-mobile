// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioLoginResponse _$UsuarioLoginResponseFromJson(
  Map<String, dynamic> json,
) => UsuarioLoginResponse(
  id: (json['id'] as num).toInt(),
  vendedor: json['vendedor'] == null
      ? null
      : VendedorResponse.fromJson(json['vendedor'] as Map<String, dynamic>),
  nomeUsuario: json['nomeUsuario'] as String,
  token: json['token'] as String,
  perfis:
      (json['perfis'] as List<dynamic>?)
          ?.map(
            (e) => UsuarioPerfilResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  empresas:
      (json['empresas'] as List<dynamic>?)
          ?.map(
            (e) => UsuarioEmpresaResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$UsuarioLoginResponseToJson(
  UsuarioLoginResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'vendedor': instance.vendedor,
  'nomeUsuario': instance.nomeUsuario,
  'token': instance.token,
  'perfis': instance.perfis,
  'empresas': instance.empresas,
};
