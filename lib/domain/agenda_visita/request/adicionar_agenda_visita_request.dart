class AdicionarAgendaVisitaRequest {
  final String dataAgendada;
  final int? duracaoPrevista;
  final String? objetivo;
  final String? observacao;
  final int? vendedorId;
  final int? empresaId;
  final int? clienteId;
  final int? agendaVisitaStatusId;
  final double? latitude;
  final double? longitude;
  final bool? criadoOffline;
  final String? uuidOffline;

  AdicionarAgendaVisitaRequest({
    required this.dataAgendada,
    this.empresaId,
    this.duracaoPrevista,
    this.objetivo,
    this.observacao,
    this.vendedorId,
    this.clienteId,
    this.agendaVisitaStatusId,
    this.latitude,
    this.longitude,
    this.criadoOffline,
    this.uuidOffline,
  });

  AdicionarAgendaVisitaRequest copyWith({
    String? dataAgendada,
    int? duracaoPrevista,
    String? objetivo,
    String? observacao,
    int? vendedorId,
    int? empresaId,
    int? clienteId,
    int? agendaVisitaStatusId,
    double? latitude,
    double? longitude,
    bool? criadoOffline,
    String? uuidOffline,
  }) {
    return AdicionarAgendaVisitaRequest(
      dataAgendada: dataAgendada ?? this.dataAgendada,
      duracaoPrevista: duracaoPrevista ?? this.duracaoPrevista,
      objetivo: objetivo ?? this.objetivo,
      observacao: observacao ?? this.observacao,
      vendedorId: vendedorId ?? this.vendedorId,
      empresaId: empresaId ?? this.empresaId,
      clienteId: clienteId ?? this.clienteId,
      agendaVisitaStatusId: agendaVisitaStatusId ?? this.agendaVisitaStatusId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      criadoOffline: criadoOffline ?? this.criadoOffline,
      uuidOffline: uuidOffline ?? this.uuidOffline,
    );
  }

  factory AdicionarAgendaVisitaRequest.fromJson(Map<String, dynamic> json) {
    return AdicionarAgendaVisitaRequest(
      dataAgendada: (json['dataAgendada'] as String?) ?? '',
      empresaId: (json['empresaId'] as int?) ?? 0,
      duracaoPrevista: json['duracaoPrevista'] as int?,
      objetivo: json['objetivo'] as String?,
      observacao: json['observacao'] as String?,
      vendedorId: (json['vendedorId'] as int?) ?? 0,
      clienteId: json['clienteId'] as int?,
      agendaVisitaStatusId: json['agendaVisitaStatusId'] as int?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      criadoOffline: json['criadoOffline'] as bool?,
      uuidOffline: json['uuidOffline'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataAgendada': dataAgendada,
      'empresaId': empresaId,
      'duracaoPrevista': duracaoPrevista,
      'objetivo': objetivo,
      'observacao': observacao,
      'vendedorId': vendedorId,
      'clienteId': clienteId,
      'agendaVisitaStatusId': agendaVisitaStatusId,
      'latitude': latitude,
      'longitude': longitude,
      'criadoOffline': criadoOffline,
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
