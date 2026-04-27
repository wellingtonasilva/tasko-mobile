// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adicionar_usuario_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdicionarUsuarioRequest _$AdicionarUsuarioRequestFromJson(
  Map<String, dynamic> json,
) => AdicionarUsuarioRequest(
  nomeUsuario: json['nomeUsuario'] as String,
  senha: json['senha'] as String,
  vendedorId: (json['vendedorId'] as num).toInt(),
);

Map<String, dynamic> _$AdicionarUsuarioRequestToJson(
  AdicionarUsuarioRequest instance,
) => <String, dynamic>{
  'nomeUsuario': instance.nomeUsuario,
  'senha': instance.senha,
  'vendedorId': instance.vendedorId,
};
