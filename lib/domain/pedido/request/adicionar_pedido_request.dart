class AdicionarPedidoRequest {
  final int clienteId;
  final int empresaId;
  final int vendedorId;
  final int? pedidoStatusTipoId;
  final String dataPedido;
  final String? dataEntregaPrevista;
  final String? observacao;
  final double subtotal;
  final double? percentualDesconto;
  final double? valorDesconto;
  final double? valorFrete;
  final double valorTotal;
  final int? formaPagamentoId;
  final int? condicaoPagamentoId;
  final double? latitude;
  final double? longitude;
  final String? uuidOffline;

  AdicionarPedidoRequest({
    required this.clienteId,
    required this.empresaId,
    required this.vendedorId,
    this.pedidoStatusTipoId,
    required this.dataPedido,
    this.dataEntregaPrevista,
    this.observacao,
    required this.subtotal,
    this.percentualDesconto,
    this.valorDesconto,
    this.valorFrete,
    required this.valorTotal,
    this.formaPagamentoId,
    this.condicaoPagamentoId,
    this.latitude,
    this.longitude,
    this.uuidOffline,
  });

  AdicionarPedidoRequest copyWith({
    int? clienteId,
    int? empresaId,
    int? vendedorId,
    int? pedidoStatusTipoId,
    String? dataPedido,
    String? dataEntregaPrevista,
    String? observacao,
    double? subtotal,
    double? percentualDesconto,
    double? valorDesconto,
    double? valorFrete,
    double? valorTotal,
    int? formaPagamentoId,
    int? condicaoPagamentoId,
    double? latitude,
    double? longitude,
    String? uuidOffline,
  }) {
    return AdicionarPedidoRequest(
      clienteId: clienteId ?? this.clienteId,
      empresaId: empresaId ?? this.empresaId,
      vendedorId: vendedorId ?? this.vendedorId,
      pedidoStatusTipoId: pedidoStatusTipoId ?? this.pedidoStatusTipoId,
      dataPedido: dataPedido ?? this.dataPedido,
      dataEntregaPrevista: dataEntregaPrevista ?? this.dataEntregaPrevista,
      observacao: observacao ?? this.observacao,
      subtotal: subtotal ?? this.subtotal,
      percentualDesconto: percentualDesconto ?? this.percentualDesconto,
      valorDesconto: valorDesconto ?? this.valorDesconto,
      valorFrete: valorFrete ?? this.valorFrete,
      valorTotal: valorTotal ?? this.valorTotal,
      formaPagamentoId: formaPagamentoId ?? this.formaPagamentoId,
      condicaoPagamentoId: condicaoPagamentoId ?? this.condicaoPagamentoId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      uuidOffline: uuidOffline ?? this.uuidOffline,
    );
  }

  factory AdicionarPedidoRequest.fromJson(Map<String, dynamic> json) {
    return AdicionarPedidoRequest(
      clienteId: (json['clienteId'] as int?) ?? 0,
      empresaId: (json['empresaId'] as int?) ?? 0,
      vendedorId: (json['vendedorId'] as int?) ?? 0,
      pedidoStatusTipoId: json['pedidoStatusTipoId'] as int?,
      dataPedido: (json['dataPedido'] as String?) ?? '',
      dataEntregaPrevista: json['dataEntregaPrevista'] as String?,
      observacao: json['observacao'] as String?,
      subtotal: _toDouble(json['subtotal']) ?? 0,
      percentualDesconto: _toDouble(json['percentualDesconto']),
      valorDesconto: _toDouble(json['valorDesconto']),
      valorFrete: _toDouble(json['valorFrete']),
      valorTotal: _toDouble(json['valorTotal']) ?? 0,
      formaPagamentoId: json['formaPagamentoId'] as int?,
      condicaoPagamentoId: json['condicaoPagamentoId'] as int?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      uuidOffline: json['uuidOffline'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empresaId': empresaId,
      'clienteId': clienteId,
      'vendedorId': vendedorId,
      'pedidoStatusTipoId': pedidoStatusTipoId,
      'dataPedido': dataPedido,
      'dataEntregaPrevista': dataEntregaPrevista,
      'observacao': observacao,
      'subtotal': subtotal,
      'percentualDesconto': percentualDesconto,
      'valorDesconto': valorDesconto,
      'valorFrete': valorFrete,
      'valorTotal': valorTotal,
      'formaPagamentoId': formaPagamentoId,
      'condicaoPagamentoId': condicaoPagamentoId,
      'latitude': latitude,
      'longitude': longitude,
      'uuidOffline': uuidOffline,
    };
  }

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
