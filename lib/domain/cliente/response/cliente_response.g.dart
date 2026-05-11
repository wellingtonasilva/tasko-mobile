// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClienteResponse _$ClienteResponseFromJson(Map<String, dynamic> json) =>
    ClienteResponse(
      id: (json['id'] as num).toInt(),
      empresaId: (json['empresaId'] as num?)?.toInt(),
      vendedorId: (json['vendedorId'] as num?)?.toInt(),
      codigoCliente: json['codigoCliente'] as String?,
      razaoSocial: json['razaoSocial'] as String,
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
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      limiteCredito: (json['limiteCredito'] as num?)?.toDouble(),
      prazoPagamento: (json['prazoPagamento'] as num?)?.toInt(),
      dataUltimoPedido: json['dataUltimoPedido'] == null
          ? null
          : DateTime.parse(json['dataUltimoPedido'] as String),
      valorUltimaCompra: (json['valorUltimaCompra'] as num?)?.toDouble(),
      bloqueado: json['bloqueado'] as bool?,
      motivoBloqueio: json['motivoBloqueio'] as String?,
      auditoria: json['auditoria'] == null
          ? null
          : Auditoria.fromJson(json['auditoria'] as Map<String, dynamic>),
      numeroTelefone: json['numeroTelefone'] as String?,
      numeroTelefoneSecundario: json['numeroTelefoneSecundario'] as String?,
      email: json['email'] as String?,
      observacao: json['observacao'] as String?,
    );

Map<String, dynamic> _$ClienteResponseToJson(ClienteResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'empresaId': instance.empresaId,
      'vendedorId': instance.vendedorId,
      'codigoCliente': instance.codigoCliente,
      'razaoSocial': instance.razaoSocial,
      'nomeFantasia': instance.nomeFantasia,
      'cnpjCpf': instance.cnpjCpf,
      'inscricaoEstadual': instance.inscricaoEstadual,
      'tipo': instance.tipo,
      'segmento': instance.segmento,
      'categoria': instance.categoria,
      'cep': instance.cep,
      'logradouro': instance.logradouro,
      'logradouroNumero': instance.logradouroNumero,
      'complemento': instance.complemento,
      'bairro': instance.bairro,
      'cidade': instance.cidade,
      'estado': instance.estado,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'limiteCredito': instance.limiteCredito,
      'prazoPagamento': instance.prazoPagamento,
      'dataUltimoPedido': instance.dataUltimoPedido?.toIso8601String(),
      'valorUltimaCompra': instance.valorUltimaCompra,
      'bloqueado': instance.bloqueado,
      'motivoBloqueio': instance.motivoBloqueio,
      'numeroTelefone': instance.numeroTelefone,
      'numeroTelefoneSecundario': instance.numeroTelefoneSecundario,
      'email': instance.email,
      'observacao': instance.observacao,
      'auditoria': instance.auditoria,
    };
