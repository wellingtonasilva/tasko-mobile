class AtualizarAgendaVisitaRequest {
  final String? dataRealizada;
  final int? duracaoReal;
  final String? resultado;
  final String? observacao;
  final int? agendaVisitaStatusId;

  AtualizarAgendaVisitaRequest({
    this.dataRealizada,
    this.duracaoReal,
    this.resultado,
    this.observacao,
    this.agendaVisitaStatusId,
  });

  factory AtualizarAgendaVisitaRequest.fromJson(Map<String, dynamic> json) {
    return AtualizarAgendaVisitaRequest(
      dataRealizada: json['dataRealizada'] as String?,
      duracaoReal: json['duracaoReal'] as int?,
      resultado: json['resultado'] as String?,
      observacao: json['observacao'] as String?,
      agendaVisitaStatusId: json['agendaVisitaStatusId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataRealizada': dataRealizada,
      'duracaoReal': duracaoReal,
      'resultado': resultado,
      'observacao': observacao,
      'agendaVisitaStatusId': agendaVisitaStatusId,
    };
  }
}
