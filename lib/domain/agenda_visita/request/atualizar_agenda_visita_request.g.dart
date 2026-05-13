// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_agenda_visita_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarAgendaVisitaRequest _$AtualizarAgendaVisitaRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarAgendaVisitaRequest(
  id: (json['id'] as num?)?.toInt(),
  dataAgendada: json['dataAgendada'] as String?,
  dataRealizada: json['dataRealizada'] as String?,
  duracaoPrevista: (json['duracaoPrevista'] as num?)?.toInt(),
  duracaoReal: (json['duracaoReal'] as num?)?.toInt(),
  objetivo: json['objetivo'] as String?,
  observacao: json['observacao'] as String?,
  resultado: json['resultado'] as String?,
  vendedorId: (json['vendedorId'] as num?)?.toInt(),
  clienteId: (json['clienteId'] as num?)?.toInt(),
  agendaVisitaStatusId: (json['agendaVisitaStatusId'] as num?)?.toInt(),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  pedidoGerado: json['pedidoGerado'] as bool?,
  pedidoId: (json['pedidoId'] as num?)?.toInt(),
  valorPedido: (json['valorPedido'] as num?)?.toDouble(),
  sincronizado: json['sincronizado'] as bool?,
  criadoOffline: json['criadoOffline'] as bool?,
  uuidOffline: json['uuidOffline'] as String?,
);

Map<String, dynamic> _$AtualizarAgendaVisitaRequestToJson(
  AtualizarAgendaVisitaRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'dataAgendada': instance.dataAgendada,
  'dataRealizada': instance.dataRealizada,
  'duracaoPrevista': instance.duracaoPrevista,
  'duracaoReal': instance.duracaoReal,
  'objetivo': instance.objetivo,
  'observacao': instance.observacao,
  'resultado': instance.resultado,
  'vendedorId': instance.vendedorId,
  'clienteId': instance.clienteId,
  'agendaVisitaStatusId': instance.agendaVisitaStatusId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'pedidoGerado': instance.pedidoGerado,
  'pedidoId': instance.pedidoId,
  'valorPedido': instance.valorPedido,
  'sincronizado': instance.sincronizado,
  'criadoOffline': instance.criadoOffline,
  'uuidOffline': instance.uuidOffline,
};
