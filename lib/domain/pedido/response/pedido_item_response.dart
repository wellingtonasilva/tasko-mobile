import 'package:tasko_mobile/common/domain/auditoria.dart';

class PedidoItemResponse {
  final int id;
  final int pedidoId;
  final int produtoId;
  final double quantidade;
  final double precoUnitario;
  final double? percentualDesconto;
  final double? valorDesconto;
  final double valorTotal;
  final Auditoria? auditoria;

  PedidoItemResponse({
    required this.id,
    required this.pedidoId,
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitario,
    this.percentualDesconto,
    this.valorDesconto,
    required this.valorTotal,
    this.auditoria,
  });

  factory PedidoItemResponse.fromJson(Map<String, dynamic> json) {
    return PedidoItemResponse(
      id: (json['id'] as int?) ?? 0,
      pedidoId: (json['pedidoId'] as int?) ?? 0,
      produtoId: (json['produtoId'] as int?) ?? 0,
      quantidade: _toDouble(json['quantidade']) ?? 0,
      precoUnitario: _toDouble(json['precoUnitario']) ?? 0,
      percentualDesconto: _toDouble(json['percentualDesconto']),
      valorDesconto: _toDouble(json['valorDesconto']),
      valorTotal: _toDouble(json['valorTotal']) ?? 0,
      auditoria: _toAuditoria(json['auditoria']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'produtoId': produtoId,
      'quantidade': quantidade,
      'precoUnitario': precoUnitario,
      'percentualDesconto': percentualDesconto,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
      'auditoria': auditoria == null
          ? null
          : {
              'criadoEm': auditoria?.criadoEm?.toIso8601String(),
              'atualizadoEm': auditoria?.atualizadoEm?.toIso8601String(),
              'indicadorAtivo': auditoria?.indicadorAtivo,
            },
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
