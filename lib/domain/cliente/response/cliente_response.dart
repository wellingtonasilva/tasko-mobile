import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';

part 'cliente_response.g.dart';

@JsonSerializable()
class ClienteResponse {
  final int id;
  final int? empresaId;
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
  final String? logradouroNumero;
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
  final bool? bloqueado;
  final String? motivoBloqueio;
  final String? numeroTelefone;
  final String? numeroTelefoneSecundario;
  final String? email;
  final String? observacao;
  final Auditoria? auditoria;

  ClienteResponse({
    required this.id,
    this.empresaId,
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
    this.logradouroNumero,
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
    this.bloqueado,
    this.motivoBloqueio,
    this.auditoria,
    this.numeroTelefone,
    this.numeroTelefoneSecundario,
    this.email,
    this.observacao,
  });

  ClienteResponse copyWith({
    int? id,
    int? empresaId,
    int? vendedorId,
    String? codigoCliente,
    String? razaoSocial,
    String? nomeFantasia,
    String? cnpjCpf,
    String? inscricaoEstadual,
    String? tipo,
    String? segmento,
    String? categoria,
    String? cep,
    String? logradouro,
    String? logradouroNumero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? estado,
    double? latitude,
    double? longitude,
    double? limiteCredito,
    int? prazoPagamento,
    DateTime? dataUltimoPedido,
    double? valorUltimaCompra,
    bool? bloqueado,
    String? motivoBloqueio,
    Auditoria? auditoria,
    String? numeroTelefone,
    String? numeroTelefoneSecundario,
    String? email,
    String? observacao,
  }) {
    return ClienteResponse(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      vendedorId: vendedorId ?? this.vendedorId,
      codigoCliente: codigoCliente ?? this.codigoCliente,
      razaoSocial: razaoSocial ?? this.razaoSocial,
      nomeFantasia: nomeFantasia ?? this.nomeFantasia,
      cnpjCpf: cnpjCpf ?? this.cnpjCpf,
      inscricaoEstadual: inscricaoEstadual ?? this.inscricaoEstadual,
      tipo: tipo ?? this.tipo,
      segmento: segmento ?? this.segmento,
      categoria: categoria ?? this.categoria,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      logradouroNumero:
          logradouroNumero ?? this.logradouroNumero, // Corrigido aqui
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      limiteCredito: limiteCredito ?? this.limiteCredito,
      prazoPagamento: prazoPagamento ?? this.prazoPagamento,
      dataUltimoPedido:
          dataUltimoPedido ?? this.dataUltimoPedido, // Corrigido aqui
      valorUltimaCompra:
          valorUltimaCompra ?? this.valorUltimaCompra, // Corrigido aqui
      bloqueado: bloqueado ?? this.bloqueado,
      motivoBloqueio: motivoBloqueio ?? this.motivoBloqueio,
      auditoria: auditoria ?? this.auditoria,
      numeroTelefone: numeroTelefone ?? this.numeroTelefone,
      numeroTelefoneSecundario:
          numeroTelefoneSecundario ?? this.numeroTelefoneSecundario,
      email: email ?? this.email,
      observacao: observacao ?? this.observacao,
    );
  }

  factory ClienteResponse.fromJson(Map<String, dynamic> json) =>
      _$ClienteResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClienteResponseToJson(this);
}
/*

  ClienteResponse({
    required this.id,
    required this.empresaId,
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
    this.logradouroNumero,
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
    this.numeroTelefone,
    this.numeroTelefoneSecundario,
    this.email,
    this.observacao,
  });

  factory ClienteResponse.fromJson(Map<String, dynamic> json) {
    return ClienteResponse(
      id: (json['id'] as int?) ?? 0,
      empresaId: (json['empresaId'] as int?) ?? 0,
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
      logradouroNumero: json['logradouroNumero'] as String?,
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
      numeroTelefone: json['numeroTelefone'] as String?,
      numeroTelefoneSecundario: json['numeroTelefoneSecundario'] as String?,
      email: json['email'] as String?,
      observacao: json['observacao'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresaId': empresaId,
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
      'logradouroNumero': logradouroNumero,
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
      'numeroTelefone': numeroTelefone,
      'numeroTelefoneSecundario': numeroTelefoneSecundario,
      'email': email,
      'observacao': observacao,
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
*/