import 'package:tasko_mobile/common/domain/auditoria.dart';

class AgendaVisitaResponse {
  final int id;
  final DateTime dataAgendada;
  final DateTime? dataRealizada;
  final int? duracaoPrevista;
  final int? duracaoReal;
  final String? objetivo;
  final String? observacao;
  final String? resultado;
  final int vendedorId;
  final int? clienteId;
  final int? agendaVisitaStatusId;
  final String? agendaVisitaStatusNome;
  final double? latitude;
  final double? longitude;
  final bool pedidoGerado;
  final int? pedidoId;
  final double? valorPedido;
  final bool sincronizado;
  final bool criadoOffline;
  final String? uuidOffline;
  final Auditoria? auditoria;

  AgendaVisitaResponse({
    required this.id,
    required this.dataAgendada,
    this.dataRealizada,
    this.duracaoPrevista,
    this.duracaoReal,
    this.objetivo,
    this.observacao,
    this.resultado,
    required this.vendedorId,
    this.clienteId,
    this.agendaVisitaStatusId,
    this.agendaVisitaStatusNome,
    this.latitude,
    this.longitude,
    required this.pedidoGerado,
    this.pedidoId,
    this.valorPedido,
    required this.sincronizado,
    required this.criadoOffline,
    this.uuidOffline,
    this.auditoria,
  });

  factory AgendaVisitaResponse.fromJson(Map<String, dynamic> json) {
    return AgendaVisitaResponse(
      id: (json['id'] as int?) ?? 0,
      dataAgendada: _toDate(json['dataAgendada']) ?? DateTime.now(),
      dataRealizada: _toDate(json['dataRealizada']),
      duracaoPrevista: json['duracaoPrevista'] as int?,
      duracaoReal: json['duracaoReal'] as int?,
      objetivo: json['objetivo'] as String?,
      observacao: json['observacao'] as String?,
      resultado: json['resultado'] as String?,
      vendedorId: (json['vendedorId'] as int?) ?? 0,
      clienteId: json['clienteId'] as int?,
      agendaVisitaStatusId: json['agendaVisitaStatusId'] as int?,
      agendaVisitaStatusNome: json['agendaVisitaStatusNome'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      pedidoGerado: (json['pedidoGerado'] as bool?) ?? false,
      pedidoId: json['pedidoId'] as int?,
      valorPedido: _toDouble(json['valorPedido']),
      sincronizado: (json['sincronizado'] as bool?) ?? false,
      criadoOffline: (json['criadoOffline'] as bool?) ?? false,
      uuidOffline: json['uuidOffline'] as String?,
      auditoria: _toAuditoria(json['auditoria']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataAgendada': dataAgendada.toIso8601String(),
      'dataRealizada': dataRealizada?.toIso8601String(),
      'duracaoPrevista': duracaoPrevista,
      'duracaoReal': duracaoReal,
      'objetivo': objetivo,
      'observacao': observacao,
      'resultado': resultado,
      'vendedorId': vendedorId,
      'clienteId': clienteId,
      'agendaVisitaStatusId': agendaVisitaStatusId,
      'agendaVisitaStatusNome': agendaVisitaStatusNome,
      'latitude': latitude,
      'longitude': longitude,
      'pedidoGerado': pedidoGerado,
      'pedidoId': pedidoId,
      'valorPedido': valorPedido,
      'sincronizado': sincronizado,
      'criadoOffline': criadoOffline,
      'uuidOffline': uuidOffline,
      'auditoria': auditoria == null
          ? null
          : {
              'criadoEm': auditoria?.criadoEm?.toIso8601String(),
              'atualizadoEm': auditoria?.atualizadoEm?.toIso8601String(),
              'indicadorAtivo': auditoria?.indicadorAtivo,
            },
    };
  }

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static DateTime? _toDate(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static Auditoria? _toAuditoria(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    return Auditoria(
      criadoEm: _toDate(value['criadoEm']),
      atualizadoEm: _toDate(value['atualizadoEm']),
      indicadorAtivo: (value['indicadorAtivo'] as bool?) ?? true,
    );
  }
}
