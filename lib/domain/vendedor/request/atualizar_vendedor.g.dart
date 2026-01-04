// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_vendedor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarVendedorRequest _$AtualizarVendedorRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarVendedorRequest(
  id: (json['id'] as num).toInt(),
  codigoVendedor: json['codigoVendedor'] as String,
  nomeVendedor: json['nomeVendedor'] as String,
  numeroCPF: json['numeroCPF'] as String,
  email: json['email'] as String,
  numeroTelefone: json['numeroTelefone'] as String,
  valorMetaMensal: (json['valorMetaMensal'] as num).toDouble(),
  percentualComissao: (json['percentualComissao'] as num).toDouble(),
  ultimoSincronismo: DateTime.parse(json['ultimoSincronismo'] as String),
  codigoDispositivo: json['codigoDispositivo'] as String,
  supervisorId: (json['supervisorId'] as num).toInt(),
  territorioId: (json['territorioId'] as num).toInt(),
);

Map<String, dynamic> _$AtualizarVendedorRequestToJson(
  AtualizarVendedorRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'codigoVendedor': instance.codigoVendedor,
  'nomeVendedor': instance.nomeVendedor,
  'numeroCPF': instance.numeroCPF,
  'email': instance.email,
  'numeroTelefone': instance.numeroTelefone,
  'valorMetaMensal': instance.valorMetaMensal,
  'percentualComissao': instance.percentualComissao,
  'ultimoSincronismo': instance.ultimoSincronismo.toIso8601String(),
  'codigoDispositivo': instance.codigoDispositivo,
  'supervisorId': instance.supervisorId,
  'territorioId': instance.territorioId,
};
