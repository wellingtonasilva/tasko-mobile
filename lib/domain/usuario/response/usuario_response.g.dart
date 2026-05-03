// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioResponse _$UsuarioResponseFromJson(Map<String, dynamic> json) =>
    UsuarioResponse(
      id: (json['id'] as num).toInt(),
      nomeUsuario: json['nomeUsuario'] as String,
      vendedor: json['vendedor'] == null
          ? null
          : VendedorResponse.fromJson(json['vendedor'] as Map<String, dynamic>),
      auditoria: Auditoria.fromJson(json['auditoria'] as Map<String, dynamic>),
      perfis: (json['perfis'] as List<dynamic>)
          .map((e) => UsuarioPerfilResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UsuarioResponseToJson(UsuarioResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomeUsuario': instance.nomeUsuario,
      'vendedor': instance.vendedor,
      'auditoria': instance.auditoria,
      'perfis': instance.perfis,
    };
