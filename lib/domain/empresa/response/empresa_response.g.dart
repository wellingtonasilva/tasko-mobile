// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empresa_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmpresaResponse _$EmpresaResponseFromJson(Map<String, dynamic> json) =>
    EmpresaResponse(
      id: (json['id'] as num).toInt(),
      dominio: json['dominio'] as String,
      nomeEmpresa: json['nomeEmpresa'] as String,
      numeroCnpj: json['numeroCnpj'] as String,
      email: json['email'] as String,
      logradouro: json['logradouro'] as String,
      numero: json['numero'] as String,
      nomeCidade: json['nomeCidade'] as String,
      nomeBairro: json['nomeBairro'] as String,
      uf: json['uf'] as String,
      numeroTelefone: json['numeroTelefone'] as String,
    );

Map<String, dynamic> _$EmpresaResponseToJson(EmpresaResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dominio': instance.dominio,
      'nomeEmpresa': instance.nomeEmpresa,
      'numeroCnpj': instance.numeroCnpj,
      'email': instance.email,
      'logradouro': instance.logradouro,
      'numero': instance.numero,
      'nomeCidade': instance.nomeCidade,
      'nomeBairro': instance.nomeBairro,
      'uf': instance.uf,
      'numeroTelefone': instance.numeroTelefone,
    };
