import 'package:tasko_mobile/common/domain/auditoria.dart';

class ClienteResponse {
  final int id;
  final int? vendedorId;
  final String? codigoCliente;
  final String razaoSocial;
  final String? nomeFantasia;
  final String? cnpjCpf;
  final String? inscricaoEstadual;
  final String? tipo;
  final String? segmento;
  final String? categoria;
  final String? cep;
  final String? logradouro;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final double? latitude;
  final double? longitude;
  final double? limiteCredito;
  final int? prazoPagamento;
  final DateTime? dataUltimoPedido;
  final double? valorUltimaCompra;
  final bool bloqueado;
  final String? motivoBloqueio;
  final Auditoria? auditoria;

  ClienteResponse({
    required this.id,
    this.vendedorId,
    this.codigoCliente,
    required this.razaoSocial,
    this.nomeFantasia,
    this.cnpjCpf,
    this.inscricaoEstadual,
    this.tipo,
    this.segmento,
    this.categoria,
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.latitude,
    this.longitude,
    this.limiteCredito,
    this.prazoPagamento,
    this.dataUltimoPedido,
    this.valorUltimaCompra,
    required this.bloqueado,
    this.motivoBloqueio,
    this.auditoria,
  });

  factory ClienteResponse.fromJson(Map<String, dynamic> json) {
    return ClienteResponse(
      id: (json['id'] as int?) ?? 0,
      vendedorId: json['vendedorId'] as int?,
      codigoCliente: json['codigoCliente'] as String?,
      razaoSocial: (json['razaoSocial'] as String?) ?? '',
      nomeFantasia: json['nomeFantasia'] as String?,
      cnpjCpf: json['cnpjCpf'] as String?,
      inscricaoEstadual: json['inscricaoEstadual'] as String?,
      tipo: json['tipo'] as String?,
      segmento: json['segmento'] as String?,
      categoria: json['categoria'] as String?,
      cep: json['cep'] as String?,
      logradouro: json['logradouro'] as String?,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String?,
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      limiteCredito: _toDouble(json['limiteCredito']),
      prazoPagamento: json['prazoPagamento'] as int?,
      dataUltimoPedido: _toDate(json['dataUltimoPedido']),
      valorUltimaCompra: _toDouble(json['valorUltimaCompra']),
      bloqueado: (json['bloqueado'] as bool?) ?? false,
      motivoBloqueio: json['motivoBloqueio'] as String?,
      auditoria: _toAuditoria(json['auditoria']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendedorId': vendedorId,
      'codigoCliente': codigoCliente,
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'cnpjCpf': cnpjCpf,
      'inscricaoEstadual': inscricaoEstadual,
      'tipo': tipo,
      'segmento': segmento,
      'categoria': categoria,
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'latitude': latitude,
      'longitude': longitude,
      'limiteCredito': limiteCredito,
      'prazoPagamento': prazoPagamento,
      'dataUltimoPedido': dataUltimoPedido?.toIso8601String(),
      'valorUltimaCompra': valorUltimaCompra,
      'bloqueado': bloqueado,
      'motivoBloqueio': motivoBloqueio,
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
