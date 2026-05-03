import 'package:json_annotation/json_annotation.dart';

part 'atualizar_pedido_request.g.dart';

@JsonSerializable()
class AtualizarPedidoRequest {
  int id;
  int empresaId;
  String? numeroPedido;
  int? clienteId;
  int? vendedorId;
  int? pedidoStatusTipoId;
  String? dataPedido;
  String? dataEntregaPrevista;
  String? observacao;
  double? subtotal;
  double? percentualDesconto;
  double? valorDesconto;
  double? valorFrete;
  double? valorTotal;
  int? formaPagamentoId;
  int? condicaoPagamentoId;
  double? latitude;
  double? longitude;
  bool? sincronizado;
  bool? criadoOffline;
  String? uuidOffline;

  AtualizarPedidoRequest({
    required this.id,
    required this.empresaId,
    this.numeroPedido,
    this.clienteId,
    this.vendedorId,
    this.pedidoStatusTipoId,
    this.dataPedido,
    this.dataEntregaPrevista,
    this.observacao,
    this.subtotal,
    this.percentualDesconto,
    this.valorDesconto,
    this.valorFrete,
    this.valorTotal,
    this.formaPagamentoId,
    this.condicaoPagamentoId,
    this.latitude,
    this.longitude,
    this.sincronizado,
    this.criadoOffline,
    this.uuidOffline,
  });

  factory AtualizarPedidoRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarPedidoRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AtualizarPedidoRequestToJson(this);
}
