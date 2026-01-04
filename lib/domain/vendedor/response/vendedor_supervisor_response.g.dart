// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendedor_supervisor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendedorSupervisorResponse _$VendedorSupervisorResponseFromJson(
  Map<String, dynamic> json,
) => VendedorSupervisorResponse(
  id: (json['id'] as num).toInt(),
  nomeSupervisor: json['nomeSupervisor'] as String,
  auditoria: Auditoria.fromJson(json['auditoria'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VendedorSupervisorResponseToJson(
  VendedorSupervisorResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'nomeSupervisor': instance.nomeSupervisor,
  'auditoria': instance.auditoria,
};
