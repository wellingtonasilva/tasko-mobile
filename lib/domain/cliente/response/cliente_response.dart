import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';

part 'cliente_response.g.dart';

@JsonSerializable()
class ClienteResponse extends Equatable {
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

  const ClienteResponse({
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

  @override
  List<Object?> get props {
    return [
      id,
      empresaId,
      vendedorId,
      codigoCliente,
      razaoSocial,
      nomeFantasia,
      cnpjCpf,
      inscricaoEstadual,
      tipo,
      segmento,
      categoria,
      cep,
      logradouro,
      logradouroNumero,
      complemento,
      bairro,
      cidade,
      estado,
      latitude,
      longitude,
      limiteCredito,
      prazoPagamento,
      dataUltimoPedido,
      valorUltimaCompra,
      bloqueado,
      motivoBloqueio,
      auditoria,
      numeroTelefone,
      numeroTelefoneSecundario,
      email,
      observacao,
    ];
  }

  @override
  bool get stringify => true;
}
