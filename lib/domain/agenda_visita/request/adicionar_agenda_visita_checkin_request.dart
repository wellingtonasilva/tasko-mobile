class AdicionarAgendaVisitaCheckinRequest {
  final int agendaVisitaId;
  final int vendedorId;
  final int? clienteId;
  final int? checkinTipoId;
  final String? observacao;
  final double? latitude;
  final double? longitude;
  final double? distanciaCliente;
  final bool? dentroRaioPermitido;
  final bool? sincronizado;
  final String? uuidOffline;

  AdicionarAgendaVisitaCheckinRequest({
    required this.agendaVisitaId,
    required this.vendedorId,
    this.clienteId,
    this.checkinTipoId,
    this.observacao,
    this.latitude,
    this.longitude,
    this.distanciaCliente,
    this.dentroRaioPermitido,
    this.sincronizado,
    this.uuidOffline,
  });

  factory AdicionarAgendaVisitaCheckinRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdicionarAgendaVisitaCheckinRequest(
      agendaVisitaId: (json['agendaVisitaId'] as int?) ?? 0,
      vendedorId: (json['vendedorId'] as int?) ?? 0,
      clienteId: json['clienteId'] as int?,
      checkinTipoId: json['checkinTipoId'] as int?,
      observacao: json['observacao'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      distanciaCliente: _toDouble(json['distanciaCliente']),
      dentroRaioPermitido: json['dentroRaioPermitido'] as bool?,
      sincronizado: json['sincronizado'] as bool?,
      uuidOffline: json['uuidOffline'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agendaVisitaId': agendaVisitaId,
      'vendedorId': vendedorId,
      'clienteId': clienteId,
      'checkinTipoId': checkinTipoId,
      'observacao': observacao,
      'latitude': latitude,
      'longitude': longitude,
      'distanciaCliente': distanciaCliente,
      'dentroRaioPermitido': dentroRaioPermitido,
      'sincronizado': sincronizado,
      'uuidOffline': uuidOffline,
    };
  }

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
