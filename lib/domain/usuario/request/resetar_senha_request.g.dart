// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resetar_senha_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetarSenhaRequest _$ResetarSenhaRequestFromJson(Map<String, dynamic> json) =>
    ResetarSenhaRequest(
      token: json['token'] as String,
      novaSenha: json['novaSenha'] as String,
    );

Map<String, dynamic> _$ResetarSenhaRequestToJson(
  ResetarSenhaRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'novaSenha': instance.novaSenha,
};
