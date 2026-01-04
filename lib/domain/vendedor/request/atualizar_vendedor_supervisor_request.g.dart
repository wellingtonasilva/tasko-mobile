// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_vendedor_supervisor_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarVendedorSupervisorRequest _$AtualizarVendedorSupervisorRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarVendedorSupervisorRequest(
  id: (json['id'] as num).toInt(),
  nomeSupervisor: json['nomeSupervisor'] as String,
);

Map<String, dynamic> _$AtualizarVendedorSupervisorRequestToJson(
  AtualizarVendedorSupervisorRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'nomeSupervisor': instance.nomeSupervisor,
};
