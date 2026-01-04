// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adicionar_vendedor_territorio_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdicionarVendedorTerritorioRequest _$AdicionarVendedorTerritorioRequestFromJson(
  Map<String, dynamic> json,
) => AdicionarVendedorTerritorioRequest(
  nomeTerritorio: json['nomeTerritorio'] as String,
  descricaoTerritorio: json['descricaoTerritorio'] as String,
  nomeRegiao: json['nomeRegiao'] as String,
  estado: json['estado'] as String,
  coordenadasPoligono: json['coordenadasPoligono'] as String,
  supervisorId: (json['supervisorId'] as num).toInt(),
);

Map<String, dynamic> _$AdicionarVendedorTerritorioRequestToJson(
  AdicionarVendedorTerritorioRequest instance,
) => <String, dynamic>{
  'nomeTerritorio': instance.nomeTerritorio,
  'descricaoTerritorio': instance.descricaoTerritorio,
  'nomeRegiao': instance.nomeRegiao,
  'estado': instance.estado,
  'coordenadasPoligono': instance.coordenadasPoligono,
  'supervisorId': instance.supervisorId,
};
