import 'dart:convert';

import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';

class ProdutoResponse {
  final int? id;
  final int? empresaId;
  final String? codigoProduto;
  final String? nomeProduto;
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
  final List<ProdutoCodigoBarrasResponse>? codigosBarras;
  final Auditoria? auditoria;
  final String? descricaoGrupo;
  final String? descricaoSubgrupo;
  final String? descricaoUnidadeMedida;
  final String? descricaoUnidadeMedidaCodigo;

  ProdutoResponse({
    this.id,
    this.empresaId,
    this.codigoProduto,
    this.nomeProduto,
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
    this.codigosBarras,
    this.auditoria,
    this.descricaoGrupo,
    this.descricaoSubgrupo,
    this.descricaoUnidadeMedida,
    this.descricaoUnidadeMedidaCodigo,
  });

  ProdutoResponse copyWith({
    int? id,
    int? empresaId,
    String? codigoProduto,
    String? nomeProduto,
    String? descricaoProduto,
    int? unidadeMedidaId,
    String? unidadeMedidaNome,
    int? grupoId,
    String? grupoNome,
    int? subgrupoId,
    String? subgrupoNome,
    double? pesoLiquido,
    String? marca,
    String? fornecedor,
    double? aliquotaIcms,
    double? aliquotaIpi,
    double? dimensaoAltura,
    double? dimensaoLargura,
    double? dimensaoProfundidade,
    double? precoCusto,
    double? precoSugerido,
    double? margemMinima,
    double? quantidadeDisponivel,
    double? quantidadeReservada,
    List<ProdutoCodigoBarrasResponse>? codigosBarras,
    Auditoria? auditoria,
    String? descricaoGrupo,
    String? descricaoSubgrupo,
    String? descricaoUnidadeMedida,
    String? descricaoUnidadeMedidaCodigo,
  }) {
    return ProdutoResponse(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      codigoProduto: codigoProduto ?? this.codigoProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      descricaoProduto: descricaoProduto ?? this.descricaoProduto,
      unidadeMedidaId: unidadeMedidaId ?? this.unidadeMedidaId,
      unidadeMedidaNome: unidadeMedidaNome ?? this.unidadeMedidaNome,
      grupoId: grupoId ?? this.grupoId,
      grupoNome: grupoNome ?? this.grupoNome,
      subgrupoId: subgrupoId ?? this.subgrupoId,
      subgrupoNome: subgrupoNome ?? this.subgrupoNome,
      pesoLiquido: pesoLiquido ?? this.pesoLiquido,
      marca: marca ?? this.marca,
      fornecedor: fornecedor ?? this.fornecedor,
      aliquotaIcms: aliquotaIcms ?? this.aliquotaIcms,
      aliquotaIpi: aliquotaIpi ?? this.aliquotaIpi,
      dimensaoAltura: dimensaoAltura ?? this.dimensaoAltura,
      dimensaoLargura: dimensaoLargura ?? this.dimensaoLargura,
      dimensaoProfundidade: dimensaoProfundidade ?? this.dimensaoProfundidade,
      precoCusto: precoCusto ?? this.precoCusto,
      precoSugerido: precoSugerido ?? this.precoSugerido,
      margemMinima: margemMinima ?? this.margemMinima,
      quantidadeDisponivel: quantidadeDisponivel ?? this.quantidadeDisponivel,
      quantidadeReservada: quantidadeReservada ?? this.quantidadeReservada,
      codigosBarras: codigosBarras ?? this.codigosBarras,
      auditoria: auditoria ?? this.auditoria,
      descricaoGrupo: descricaoGrupo ?? this.descricaoGrupo,
      descricaoSubgrupo: descricaoSubgrupo ?? this.descricaoSubgrupo,
      descricaoUnidadeMedida:
          descricaoUnidadeMedida ?? this.descricaoUnidadeMedida,
      descricaoUnidadeMedidaCodigo:
          descricaoUnidadeMedidaCodigo ?? this.descricaoUnidadeMedidaCodigo,
    );
  }

  factory ProdutoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoResponse(
      id: _toInt(json['id']) ?? 0,
      empresaId: _toInt(json['empresaId']) ?? 0,
      codigoProduto: json['codigoProduto'] as String?,
      nomeProduto: json['nomeProduto'] as String?,
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
      descricaoGrupo: json['descricaoGrupo'] as String?,
      descricaoSubgrupo: json['descricaoSubgrupo'] as String?,
      descricaoUnidadeMedida: json['descricaoUnidadeMedida'] as String?,
      descricaoUnidadeMedidaCodigo:
          json['descricaoUnidadeMedidaCodigo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresaId': empresaId,
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
      'codigosBarras': codigosBarras?.map((e) => e.toJson()).toList(),
      'auditoria': auditoria == null
          ? null
          : {
              'criadoEm': auditoria?.criadoEm?.toIso8601String(),
              'atualizadoEm': auditoria?.atualizadoEm?.toIso8601String(),
              'indicadorAtivo': auditoria?.indicadorAtivo,
            },
      'descricaoGrupo': descricaoGrupo,
      'descricaoSubgrupo': descricaoSubgrupo,
      'descricaoUnidadeMedida': descricaoUnidadeMedida,
      'descricaoUnidadeMedidaCodigo': descricaoUnidadeMedidaCodigo,
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
