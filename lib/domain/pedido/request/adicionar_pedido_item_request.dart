class AdicionarPedidoItemRequest {
  final int pedidoId;
  final int produtoId;
  final double quantidade;
  final double precoUnitario;
  final double? percentualDesconto;
  final double? valorDesconto;
  final double valorTotal;

  AdicionarPedidoItemRequest({
    required this.pedidoId,
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitario,
    this.percentualDesconto,
    this.valorDesconto,
    required this.valorTotal,
  });

  factory AdicionarPedidoItemRequest.fromJson(Map<String, dynamic> json) {
    return AdicionarPedidoItemRequest(
      pedidoId: (json['pedidoId'] as int?) ?? 0,
      produtoId: (json['produtoId'] as int?) ?? 0,
      quantidade: _toDouble(json['quantidade']) ?? 0,
      precoUnitario: _toDouble(json['precoUnitario']) ?? 0,
      percentualDesconto: _toDouble(json['percentualDesconto']),
      valorDesconto: _toDouble(json['valorDesconto']),
      valorTotal: _toDouble(json['valorTotal']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pedidoId': pedidoId,
      'produtoId': produtoId,
      'quantidade': quantidade,
      'precoUnitario': precoUnitario,
      'percentualDesconto': percentualDesconto,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
    };
  }

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
