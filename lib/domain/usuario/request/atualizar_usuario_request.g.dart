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
  nomeCompleto: json['nomeCompleto'] as String?,
  numeroTelefone: json['numeroTelefone'] as String?,
  vendedorId: (json['vendedorId'] as num?)?.toInt(),
  indicadorAtivo: json['indicadorAtivo'] as bool?,
);

Map<String, dynamic> _$AtualizarUsuarioRequestToJson(
  AtualizarUsuarioRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'nomeUsuario': instance.nomeUsuario,
  'nomeCompleto': instance.nomeCompleto,
  'numeroTelefone': instance.numeroTelefone,
  'vendedorId': instance.vendedorId,
  'indicadorAtivo': instance.indicadorAtivo,
};
