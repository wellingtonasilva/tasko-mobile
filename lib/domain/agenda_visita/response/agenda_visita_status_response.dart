import 'package:equatable/equatable.dart';

class AgendaVisitaStatusResponse extends Equatable {
  final int id;
  final String? descricaoVisitaStatus;

  const AgendaVisitaStatusResponse({
    required this.id,
    this.descricaoVisitaStatus,
  });

  factory AgendaVisitaStatusResponse.fromJson(Map<String, dynamic> json) {
    return AgendaVisitaStatusResponse(
      id: (json['id'] as int?) ?? 0,
      descricaoVisitaStatus: json['descricaoVisitaStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricaoVisitaStatus': descricaoVisitaStatus};
  }

  @override
  List<Object?> get props => [id, descricaoVisitaStatus];
}
