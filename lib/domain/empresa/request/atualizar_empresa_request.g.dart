// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_empresa_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarEmpresaRequest _$AtualizarEmpresaRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarEmpresaRequest(
  id: (json['id'] as num).toInt(),
  nomeEmpresa: json['nomeEmpresa'] as String,
  email: json['email'] as String,
  logradouro: json['logradouro'] as String,
  numero: json['numero'] as String,
  nomeCidade: json['nomeCidade'] as String,
  nomeBairro: json['nomeBairro'] as String,
  uf: json['uf'] as String,
  numeroTelefone: json['numeroTelefone'] as String,
);

Map<String, dynamic> _$AtualizarEmpresaRequestToJson(
  AtualizarEmpresaRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'nomeEmpresa': instance.nomeEmpresa,
  'email': instance.email,
  'logradouro': instance.logradouro,
  'numero': instance.numero,
  'nomeCidade': instance.nomeCidade,
  'nomeBairro': instance.nomeBairro,
  'uf': instance.uf,
  'numeroTelefone': instance.numeroTelefone,
};
