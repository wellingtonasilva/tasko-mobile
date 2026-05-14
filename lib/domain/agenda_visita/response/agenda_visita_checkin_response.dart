import 'package:equatable/equatable.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';

class AgendaVisitaCheckinResponse extends Equatable {
  final int id;
  final int agendaVisitaId;
  final int vendedorId;
  final int? clienteId;
  final int? checkinTipoId;
  final String? checkinTipoNome;
  final String? observacao;
  final double? latitude;
  final double? longitude;
  final double? distanciaCliente;
  final bool? dentroRaioPermitido;
  final bool sincronizado;
  final String? uuidOffline;
  final Auditoria? auditoria;

  const AgendaVisitaCheckinResponse({
    required this.id,
    required this.agendaVisitaId,
    required this.vendedorId,
    this.clienteId,
    this.checkinTipoId,
    this.checkinTipoNome,
    this.observacao,
    this.latitude,
    this.longitude,
    this.distanciaCliente,
    this.dentroRaioPermitido,
    required this.sincronizado,
    this.uuidOffline,
    this.auditoria,
  });

  factory AgendaVisitaCheckinResponse.fromJson(Map<String, dynamic> json) {
    return AgendaVisitaCheckinResponse(
      id: (json['id'] as int?) ?? 0,
      agendaVisitaId: (json['agendaVisitaId'] as int?) ?? 0,
      vendedorId: (json['vendedorId'] as int?) ?? 0,
      clienteId: json['clienteId'] as int?,
      checkinTipoId: json['checkinTipoId'] as int?,
      checkinTipoNome: json['checkinTipoNome'] as String?,
      observacao: json['observacao'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      distanciaCliente: _toDouble(json['distanciaCliente']),
      dentroRaioPermitido: json['dentroRaioPermitido'] as bool?,
      sincronizado: (json['sincronizado'] as bool?) ?? false,
      uuidOffline: json['uuidOffline'] as String?,
      auditoria: _toAuditoria(json['auditoria']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agendaVisitaId': agendaVisitaId,
      'vendedorId': vendedorId,
      'clienteId': clienteId,
      'checkinTipoId': checkinTipoId,
      'checkinTipoNome': checkinTipoNome,
      'observacao': observacao,
      'latitude': latitude,
      'longitude': longitude,
      'distanciaCliente': distanciaCliente,
      'dentroRaioPermitido': dentroRaioPermitido,
      'sincronizado': sincronizado,
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

  @override
  List<Object?> get props {
    return [
      id,
      agendaVisitaId,
      vendedorId,
      clienteId,
      checkinTipoId,
      checkinTipoNome,
      observacao,
      latitude,
      longitude,
      distanciaCliente,
      dentroRaioPermitido,
      sincronizado,
      uuidOffline,
      auditoria,
    ];
  }
}
