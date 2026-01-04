// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_vendedor_territorio_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarVendedorTerritorioRequest _$AtualizarVendedorTerritorioRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarVendedorTerritorioRequest(
  id: (json['id'] as num).toInt(),
  nomeTerritorio: json['nomeTerritorio'] as String,
  descricaoTerritorio: json['descricaoTerritorio'] as String,
  nomeRegiao: json['nomeRegiao'] as String,
  estado: json['estado'] as String,
  coordenadasPoligono: json['coordenadasPoligono'] as String,
  supervisorId: (json['supervisorId'] as num).toInt(),
);

Map<String, dynamic> _$AtualizarVendedorTerritorioRequestToJson(
  AtualizarVendedorTerritorioRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'nomeTerritorio': instance.nomeTerritorio,
  'descricaoTerritorio': instance.descricaoTerritorio,
  'nomeRegiao': instance.nomeRegiao,
  'estado': instance.estado,
  'coordenadasPoligono': instance.coordenadasPoligono,
  'supervisorId': instance.supervisorId,
};
