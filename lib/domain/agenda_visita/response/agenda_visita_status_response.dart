class AgendaVisitaStatusResponse {
  final int id;
  final String? descricaoVisitaStatus;

  AgendaVisitaStatusResponse({required this.id, this.descricaoVisitaStatus});

  factory AgendaVisitaStatusResponse.fromJson(Map<String, dynamic> json) {
    return AgendaVisitaStatusResponse(
      id: (json['id'] as int?) ?? 0,
      descricaoVisitaStatus: json['descricaoVisitaStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricaoVisitaStatus': descricaoVisitaStatus};
  }
}
