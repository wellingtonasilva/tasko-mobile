// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_pedido_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarPedidoRequest _$AtualizarPedidoRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarPedidoRequest(
  id: (json['id'] as num).toInt(),
  empresaId: (json['empresaId'] as num).toInt(),
  numeroPedido: json['numeroPedido'] as String?,
  clienteId: (json['clienteId'] as num?)?.toInt(),
  vendedorId: (json['vendedorId'] as num?)?.toInt(),
  pedidoStatusTipoId: (json['pedidoStatusTipoId'] as num?)?.toInt(),
  dataPedido: json['dataPedido'] as String?,
  dataEntregaPrevista: json['dataEntregaPrevista'] as String?,
  observacao: json['observacao'] as String?,
  subtotal: (json['subtotal'] as num?)?.toDouble(),
  percentualDesconto: (json['percentualDesconto'] as num?)?.toDouble(),
  valorDesconto: (json['valorDesconto'] as num?)?.toDouble(),
  valorFrete: (json['valorFrete'] as num?)?.toDouble(),
  valorTotal: (json['valorTotal'] as num?)?.toDouble(),
  formaPagamentoId: (json['formaPagamentoId'] as num?)?.toInt(),
  condicaoPagamentoId: (json['condicaoPagamentoId'] as num?)?.toInt(),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  sincronizado: json['sincronizado'] as bool?,
  criadoOffline: json['criadoOffline'] as bool?,
  uuidOffline: json['uuidOffline'] as String?,
);

Map<String, dynamic> _$AtualizarPedidoRequestToJson(
  AtualizarPedidoRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'empresaId': instance.empresaId,
  'numeroPedido': instance.numeroPedido,
  'clienteId': instance.clienteId,
  'vendedorId': instance.vendedorId,
  'pedidoStatusTipoId': instance.pedidoStatusTipoId,
  'dataPedido': instance.dataPedido,
  'dataEntregaPrevista': instance.dataEntregaPrevista,
  'observacao': instance.observacao,
  'subtotal': instance.subtotal,
  'percentualDesconto': instance.percentualDesconto,
  'valorDesconto': instance.valorDesconto,
  'valorFrete': instance.valorFrete,
  'valorTotal': instance.valorTotal,
  'formaPagamentoId': instance.formaPagamentoId,
  'condicaoPagamentoId': instance.condicaoPagamentoId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'sincronizado': instance.sincronizado,
  'criadoOffline': instance.criadoOffline,
  'uuidOffline': instance.uuidOffline,
};
