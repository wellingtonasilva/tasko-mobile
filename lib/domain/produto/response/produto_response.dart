import 'dart:convert';

import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';

class ProdutoResponse {
  final int id;
  final String? codigoProduto;
  final String nomeProduto;
  final String? descricaoProduto;
  final int? unidadeMedidaId;
  final String? unidadeMedidaNome;
  final int? grupoId;
  final String? grupoNome;
  final int? subgrupoId;
  final String? subgrupoNome;
  final double? pesoLiquido;
  final String? marca;
  final String? fornecedor;
  final double? aliquotaIcms;
  final double? aliquotaIpi;
  final double? dimensaoAltura;
  final double? dimensaoLargura;
  final double? dimensaoProfundidade;
  final double? precoCusto;
  final double? precoSugerido;
  final double? margemMinima;
  final double? quantidadeDisponivel;
  final double? quantidadeReservada;
  final List<ProdutoCodigoBarrasResponse> codigosBarras;
  final Auditoria? auditoria;

  ProdutoResponse({
    required this.id,
    this.codigoProduto,
    required this.nomeProduto,
    this.descricaoProduto,
    this.unidadeMedidaId,
    this.unidadeMedidaNome,
    this.grupoId,
    this.grupoNome,
    this.subgrupoId,
    this.subgrupoNome,
    this.pesoLiquido,
    this.marca,
    this.fornecedor,
    this.aliquotaIcms,
    this.aliquotaIpi,
    this.dimensaoAltura,
    this.dimensaoLargura,
    this.dimensaoProfundidade,
    this.precoCusto,
    this.precoSugerido,
    this.margemMinima,
    this.quantidadeDisponivel,
    this.quantidadeReservada,
    required this.codigosBarras,
    this.auditoria,
  });

  factory ProdutoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoResponse(
      id: _toInt(json['id']) ?? 0,
      codigoProduto: json['codigoProduto'] as String?,
      nomeProduto: (json['nomeProduto'] as String?) ?? '',
      descricaoProduto: json['descricaoProduto'] as String?,
      unidadeMedidaId: _toInt(json['unidadeMedidaId']),
      unidadeMedidaNome: json['unidadeMedidaNome'] as String?,
      grupoId: _toInt(json['grupoId']),
      grupoNome: json['grupoNome'] as String?,
      subgrupoId: _toInt(json['subgrupoId']),
      subgrupoNome: json['subgrupoNome'] as String?,
      pesoLiquido: _toDouble(json['pesoLiquido']),
      marca: json['marca'] as String?,
      fornecedor: json['fornecedor'] as String?,
      aliquotaIcms: _toDouble(json['aliquotaIcms']),
      aliquotaIpi: _toDouble(json['aliquotaIpi']),
      dimensaoAltura: _toDouble(json['dimensaoAltura']),
      dimensaoLargura: _toDouble(json['dimensaoLargura']),
      dimensaoProfundidade: _toDouble(json['dimensaoProfundidade']),
      precoCusto: _toDouble(json['precoCusto']),
      precoSugerido: _toDouble(json['precoSugerido']),
      margemMinima: _toDouble(json['margemMinima']),
      quantidadeDisponivel: _toDouble(json['quantidadeDisponivel']),
      quantidadeReservada: _toDouble(json['quantidadeReservada']),
      codigosBarras: _toCodigosBarras(json['codigosBarras']),
      auditoria: _toAuditoria(json['auditoria']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigoProduto': codigoProduto,
      'nomeProduto': nomeProduto,
      'descricaoProduto': descricaoProduto,
      'unidadeMedidaId': unidadeMedidaId,
      'unidadeMedidaNome': unidadeMedidaNome,
      'grupoId': grupoId,
      'grupoNome': grupoNome,
      'subgrupoId': subgrupoId,
      'subgrupoNome': subgrupoNome,
      'pesoLiquido': pesoLiquido,
      'marca': marca,
      'fornecedor': fornecedor,
      'aliquotaIcms': aliquotaIcms,
      'aliquotaIpi': aliquotaIpi,
      'dimensaoAltura': dimensaoAltura,
      'dimensaoLargura': dimensaoLargura,
      'dimensaoProfundidade': dimensaoProfundidade,
      'precoCusto': precoCusto,
      'precoSugerido': precoSugerido,
      'margemMinima': margemMinima,
      'quantidadeDisponivel': quantidadeDisponivel,
      'quantidadeReservada': quantidadeReservada,
      'codigosBarras': codigosBarras.map((e) => e.toJson()).toList(),
      'auditoria': auditoria == null
          ? null
          : {
              'criadoEm': auditoria?.criadoEm?.toIso8601String(),
              'atualizadoEm': auditoria?.atualizadoEm?.toIso8601String(),
              'indicadorAtivo': auditoria?.indicadorAtivo,
            },
    };
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
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

  static List<ProdutoCodigoBarrasResponse> _toCodigosBarras(Object? value) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(ProdutoCodigoBarrasResponse.fromJson)
          .toList();
    }

    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded
              .whereType<Map<String, dynamic>>()
              .map(ProdutoCodigoBarrasResponse.fromJson)
              .toList();
        }
      } catch (_) {
        return const [];
      }
    }

    return const [];
  }
}
