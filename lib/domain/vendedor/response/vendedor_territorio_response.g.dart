// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendedor_territorio_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendedorTerritorioResponse _$VendedorTerritorioResponseFromJson(
  Map<String, dynamic> json,
) => VendedorTerritorioResponse(
  id: (json['id'] as num).toInt(),
  nomeTerritorio: json['nomeTerritorio'] as String,
  descricaoTerritorio: json['descricaoTerritorio'] as String?,
  nomeRegiao: json['nomeRegiao'] as String?,
  estado: json['estado'] as String?,
  coordenadasPoligono: json['coordenadasPoligono'] as String?,
  supervisor: json['supervisor'] == null
      ? null
      : VendedorSupervisorResponse.fromJson(
          json['supervisor'] as Map<String, dynamic>,
        ),
  auditoria: json['auditoria'] == null
      ? null
      : Auditoria.fromJson(json['auditoria'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VendedorTerritorioResponseToJson(
  VendedorTerritorioResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'nomeTerritorio': instance.nomeTerritorio,
  'descricaoTerritorio': instance.descricaoTerritorio,
  'nomeRegiao': instance.nomeRegiao,
  'estado': instance.estado,
  'coordenadasPoligono': instance.coordenadasPoligono,
  'supervisor': instance.supervisor,
  'auditoria': instance.auditoria,
};
