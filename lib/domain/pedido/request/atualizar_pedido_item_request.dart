import 'package:json_annotation/json_annotation.dart';

part 'atualizar_pedido_item_request.g.dart';

@JsonSerializable()
class AtualizarPedidoItemRequest {
  final int id;
  final int pedidoId;
  final int produtoId;
  final double quantidade;
  final double precoUnitario;
  final double? percentualDesconto;
  final double? valorDesconto;
  final double valorTotal;

  AtualizarPedidoItemRequest({
    required this.id,
    required this.pedidoId,
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitario,
    this.percentualDesconto,
    this.valorDesconto,
    required this.valorTotal,
  });

  factory AtualizarPedidoItemRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarPedidoItemRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AtualizarPedidoItemRequestToJson(this);
}
