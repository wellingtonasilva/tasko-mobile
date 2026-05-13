import 'package:json_annotation/json_annotation.dart';

part 'atualizar_agenda_visita_request.g.dart';

@JsonSerializable()
class AtualizarAgendaVisitaRequest {
  final int? id;
  final String? dataAgendada;
  final String? dataRealizada;
  final int? duracaoPrevista;
  final int? duracaoReal;
  final String? objetivo;
  final String? observacao;
  final String? resultado;
  final int? vendedorId;
  final int? clienteId;
  final int? agendaVisitaStatusId;
  final double? latitude;
  final double? longitude;
  final bool? pedidoGerado;
  final int? pedidoId;
  final double? valorPedido;
  final bool? sincronizado;
  final bool? criadoOffline;
  final String? uuidOffline;

  AtualizarAgendaVisitaRequest({
    this.id,
    this.dataAgendada,
    this.dataRealizada,
    this.duracaoPrevista,
    this.duracaoReal,
    this.objetivo,
    this.observacao,
    this.resultado,
    this.vendedorId,
    this.clienteId,
    this.agendaVisitaStatusId,
    this.latitude,
    this.longitude,
    this.pedidoGerado,
    this.pedidoId,
    this.valorPedido,
    this.sincronizado,
    this.criadoOffline,
    this.uuidOffline,
  });

  factory AtualizarAgendaVisitaRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarAgendaVisitaRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AtualizarAgendaVisitaRequestToJson(this);
}
