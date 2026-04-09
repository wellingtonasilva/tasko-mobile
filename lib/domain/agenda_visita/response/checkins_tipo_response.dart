class CheckinsTipoResponse {
  final int id;
  final String? descricaoCheckinTipo;

  CheckinsTipoResponse({required this.id, this.descricaoCheckinTipo});

  factory CheckinsTipoResponse.fromJson(Map<String, dynamic> json) {
    return CheckinsTipoResponse(
      id: (json['id'] as int?) ?? 0,
      descricaoCheckinTipo: json['descricaoCheckinTipo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricaoCheckinTipo': descricaoCheckinTipo};
  }
}
