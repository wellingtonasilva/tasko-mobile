// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adicionar_vendedor_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdicionarVendedorRequest _$AdicionarVendedorRequestFromJson(
  Map<String, dynamic> json,
) => AdicionarVendedorRequest(
  codigoVendedor: json['codigoVendedor'] as String,
  nomeVendedor: json['nomeVendedor'] as String,
  numeroCPF: json['numeroCPF'] as String,
  email: json['email'] as String,
  numeroTelefone: json['numeroTelefone'] as String,
  valorMetaMensal: (json['valorMetaMensal'] as num).toDouble(),
  percentualComissao: (json['percentualComissao'] as num).toDouble(),
  supervisorId: (json['supervisorId'] as num).toInt(),
  territorioId: (json['territorioId'] as num).toInt(),
);

Map<String, dynamic> _$AdicionarVendedorRequestToJson(
  AdicionarVendedorRequest instance,
) => <String, dynamic>{
  'codigoVendedor': instance.codigoVendedor,
  'nomeVendedor': instance.nomeVendedor,
  'numeroCPF': instance.numeroCPF,
  'email': instance.email,
  'numeroTelefone': instance.numeroTelefone,
  'valorMetaMensal': instance.valorMetaMensal,
  'percentualComissao': instance.percentualComissao,
  'supervisorId': instance.supervisorId,
  'territorioId': instance.territorioId,
};
