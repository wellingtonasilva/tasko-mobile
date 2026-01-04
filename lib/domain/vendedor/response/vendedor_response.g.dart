// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendedor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendedorResponse _$VendedorResponseFromJson(Map<String, dynamic> json) =>
    VendedorResponse(
      id: (json['id'] as num).toInt(),
      codigoVendedor: json['codigoVendedor'] as String,
      nomeVendedor: json['nomeVendedor'] as String,
      numeroCPF: json['numeroCPF'] as String,
      email: json['email'] as String,
      numeroTelefone: json['numeroTelefone'] as String,
      valorMetaMensal: (json['valorMetaMensal'] as num?)?.toDouble(),
      percentualComissao: (json['percentualComissao'] as num).toDouble(),
      ultimoSincronismo: json['ultimoSincronismo'] == null
          ? null
          : DateTime.parse(json['ultimoSincronismo'] as String),
      codigoDispositivo: json['codigoDispositivo'] as String?,
      supervisor: json['supervisor'] == null
          ? null
          : VendedorSupervisorResponse.fromJson(
              json['supervisor'] as Map<String, dynamic>,
            ),
      territorio: json['territorio'] == null
          ? null
          : VendedorTerritorioResponse.fromJson(
              json['territorio'] as Map<String, dynamic>,
            ),
      auditoria: json['auditoria'] == null
          ? null
          : Auditoria.fromJson(json['auditoria'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VendedorResponseToJson(VendedorResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigoVendedor': instance.codigoVendedor,
      'nomeVendedor': instance.nomeVendedor,
      'numeroCPF': instance.numeroCPF,
      'email': instance.email,
      'numeroTelefone': instance.numeroTelefone,
      'valorMetaMensal': instance.valorMetaMensal,
      'percentualComissao': instance.percentualComissao,
      'ultimoSincronismo': instance.ultimoSincronismo?.toIso8601String(),
      'codigoDispositivo': instance.codigoDispositivo,
      'supervisor': instance.supervisor,
      'territorio': instance.territorio,
      'auditoria': instance.auditoria,
    };
