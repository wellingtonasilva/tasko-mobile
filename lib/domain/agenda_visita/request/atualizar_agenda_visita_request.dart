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

  AtualizarAgendaVisitaRequest copyWith({
    int? id,
    String? dataAgendada,
    String? dataRealizada,
    int? duracaoPrevista,
    int? duracaoReal,
    String? objetivo,
    String? observacao,
    String? resultado,
    int? vendedorId,
    int? clienteId,
    int? agendaVisitaStatusId,
    double? latitude,
    double? longitude,
    bool? pedidoGerado,
    int? pedidoId,
    double? valorPedido,
    bool? sincronizado,
    bool? criadoOffline,
    String? uuidOffline,
  }) {
    return AtualizarAgendaVisitaRequest(
      id: id ?? this.id,
      dataAgendada: dataAgendada ?? this.dataAgendada,
      dataRealizada: dataRealizada ?? this.dataRealizada,
      duracaoPrevista: duracaoPrevista ?? this.duracaoPrevista,
      duracaoReal: duracaoReal ?? this.duracaoReal,
      objetivo: objetivo ?? this.objetivo,
      observacao: observacao ?? this.observacao,
      resultado: resultado ?? this.resultado,
      vendedorId: vendedorId ?? this.vendedorId,
      clienteId: clienteId ?? this.clienteId,
      agendaVisitaStatusId: agendaVisitaStatusId ?? this.agendaVisitaStatusId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pedidoGerado: pedidoGerado ?? this.pedidoGerado,
      pedidoId: pedidoId ?? this.pedidoId,
      valorPedido: valorPedido ?? this.valorPedido,
      sincronizado: sincronizado ?? this.sincronizado,
      criadoOffline: criadoOffline ?? this.criadoOffline,
      uuidOffline: uuidOffline ?? this.uuidOffline,
    );
  }

  factory AtualizarAgendaVisitaRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarAgendaVisitaRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AtualizarAgendaVisitaRequestToJson(this);
}
