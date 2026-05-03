// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_pedido_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarPedidoItemRequest _$AtualizarPedidoItemRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarPedidoItemRequest(
  id: (json['id'] as num).toInt(),
  pedidoId: (json['pedidoId'] as num).toInt(),
  produtoId: (json['produtoId'] as num).toInt(),
  quantidade: (json['quantidade'] as num).toDouble(),
  precoUnitario: (json['precoUnitario'] as num).toDouble(),
  percentualDesconto: (json['percentualDesconto'] as num?)?.toDouble(),
  valorDesconto: (json['valorDesconto'] as num?)?.toDouble(),
  valorTotal: (json['valorTotal'] as num).toDouble(),
);

Map<String, dynamic> _$AtualizarPedidoItemRequestToJson(
  AtualizarPedidoItemRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'pedidoId': instance.pedidoId,
  'produtoId': instance.produtoId,
  'quantidade': instance.quantidade,
  'precoUnitario': instance.precoUnitario,
  'percentualDesconto': instance.percentualDesconto,
  'valorDesconto': instance.valorDesconto,
  'valorTotal': instance.valorTotal,
};
