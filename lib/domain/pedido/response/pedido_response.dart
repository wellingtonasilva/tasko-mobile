import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';

class PedidoResponse {
  final int id;
  final int empresaId;
  final String? numeroPedido;
  final int clienteId;
  final int vendedorId;
  final int? pedidoStatusTipoId;
  final String? pedidoStatusTipoNome;
  final DateTime dataPedido;
  final DateTime? dataEntregaPrevista;
  final String? observacao;
  final double subtotal;
  final double? percentualDesconto;
  final double? valorDesconto;
  final double? valorFrete;
  final double valorTotal;
  final int? formaPagamentoId;
  final String? formaPagamentoNome;
  final int? condicaoPagamentoId;
  final String? condicaoPagamentoNome;
  final double? latitude;
  final double? longitude;
  final bool sincronizado;
  final bool criadoOffline;
  final String? uuidOffline;
  final Auditoria? auditoria;
  final List<PedidoItemResponse> itens;
  final String? descricaoCondicaoPagamento;
  final String? descricaoFormaPagamento;
  final String? nomeVendedor;
  final String? nomeFantasiaCliente;
  final String? descricaoStatusTipo;
  final String? syncStatus;
  final String? syncError;
  final int syncAttemptCount;

  PedidoResponse({
    required this.id,
    required this.empresaId,
    this.numeroPedido,
    required this.clienteId,
    required this.vendedorId,
    this.pedidoStatusTipoId,
    this.pedidoStatusTipoNome,
    required this.dataPedido,
    this.dataEntregaPrevista,
    this.observacao,
    required this.subtotal,
    this.percentualDesconto,
    this.valorDesconto,
    this.valorFrete,
    required this.valorTotal,
    this.formaPagamentoId,
    this.formaPagamentoNome,
    this.condicaoPagamentoId,
    this.condicaoPagamentoNome,
    this.latitude,
    this.longitude,
    required this.sincronizado,
    required this.criadoOffline,
    this.uuidOffline,
    this.auditoria,
    this.itens = const [],
    this.descricaoCondicaoPagamento,
    this.descricaoFormaPagamento,
    this.nomeVendedor,
    this.nomeFantasiaCliente,
    this.descricaoStatusTipo,
    this.syncStatus,
    this.syncError,
    this.syncAttemptCount = 0,
  });

  factory PedidoResponse.fromJson(Map<String, dynamic> json) {
    return PedidoResponse(
      id: (json['id'] as int?) ?? 0,
      empresaId: (json['empresaId'] as int?) ?? 0,
      numeroPedido: json['numeroPedido'] as String?,
      clienteId: (json['clienteId'] as int?) ?? 0,
      vendedorId: (json['vendedorId'] as int?) ?? 0,
      pedidoStatusTipoId: json['pedidoStatusTipoId'] as int?,
      pedidoStatusTipoNome: json['pedidoStatusTipoNome'] as String?,
      dataPedido: _toDate(json['dataPedido']) ?? DateTime.now(),
      dataEntregaPrevista: _toDate(json['dataEntregaPrevista']),
      observacao: json['observacao'] as String?,
      subtotal: _toDouble(json['subtotal']) ?? 0,
      percentualDesconto: _toDouble(json['percentualDesconto']),
      valorDesconto: _toDouble(json['valorDesconto']),
      valorFrete: _toDouble(json['valorFrete']),
      valorTotal: _toDouble(json['valorTotal']) ?? 0,
      formaPagamentoId: json['formaPagamentoId'] as int?,
      formaPagamentoNome: json['formaPagamentoNome'] as String?,
      condicaoPagamentoId: json['condicaoPagamentoId'] as int?,
      condicaoPagamentoNome: json['condicaoPagamentoNome'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      sincronizado: (json['sincronizado'] as bool?) ?? false,
      criadoOffline: (json['criadoOffline'] as bool?) ?? false,
      uuidOffline: json['uuidOffline'] as String?,
      auditoria: _toAuditoria(json['auditoria']),
      itens: _toItens(json['itens']),
      descricaoCondicaoPagamento: json['descricaoCondicaoPagamento'] as String?,
      descricaoFormaPagamento: json['descricaoFormaPagamento'] as String?,
      nomeVendedor: json['nomeVendedor'] as String?,
      nomeFantasiaCliente: json['nomeFantasiaCliente'] as String?,
      descricaoStatusTipo: json['descricaoStatusTipo'] as String?,
      syncStatus: json['syncStatus'] as String?,
      syncError: json['syncError'] as String?,
      syncAttemptCount: (json['syncAttemptCount'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresaId': empresaId,
      'numeroPedido': numeroPedido,
      'clienteId': clienteId,
      'vendedorId': vendedorId,
      'pedidoStatusTipoId': pedidoStatusTipoId,
      'pedidoStatusTipoNome': pedidoStatusTipoNome,
      'dataPedido': dataPedido.toIso8601String(),
      'dataEntregaPrevista': dataEntregaPrevista?.toIso8601String(),
      'observacao': observacao,
      'subtotal': subtotal,
      'percentualDesconto': percentualDesconto,
      'valorDesconto': valorDesconto,
      'valorFrete': valorFrete,
      'valorTotal': valorTotal,
      'formaPagamentoId': formaPagamentoId,
      'formaPagamentoNome': formaPagamentoNome,
      'condicaoPagamentoId': condicaoPagamentoId,
      'condicaoPagamentoNome': condicaoPagamentoNome,
      'latitude': latitude,
      'longitude': longitude,
      'sincronizado': sincronizado,
      'criadoOffline': criadoOffline,
      'uuidOffline': uuidOffline,
      'auditoria': auditoria == null
          ? null
          : {
              'criadoEm': auditoria?.criadoEm?.toIso8601String(),
              'atualizadoEm': auditoria?.atualizadoEm?.toIso8601String(),
              'indicadorAtivo': auditoria?.indicadorAtivo,
            },
      'itens': itens.map((item) => item.toJson()).toList(),
      'descricaoCondicaoPagamento': descricaoCondicaoPagamento,
      'descricaoFormaPagamento': descricaoFormaPagamento,
      'nomeVendedor': nomeVendedor,
      'nomeFantasiaCliente': nomeFantasiaCliente,
      'descricaoStatusTipo': descricaoStatusTipo,
      'syncStatus': syncStatus,
      'syncError': syncError,
      'syncAttemptCount': syncAttemptCount,
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

  static List<PedidoItemResponse> _toItens(Object? value) {
    if (value is! List) return [];
    return value
        .map((e) => PedidoItemResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
