// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'criar_empresa_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CriarEmpresaRequest _$CriarEmpresaRequestFromJson(Map<String, dynamic> json) =>
    CriarEmpresaRequest(
      nomeEmpresa: json['nomeEmpresa'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String,
    );

Map<String, dynamic> _$CriarEmpresaRequestToJson(
  CriarEmpresaRequest instance,
) => <String, dynamic>{
  'nomeEmpresa': instance.nomeEmpresa,
  'email': instance.email,
  'senha': instance.senha,
};
