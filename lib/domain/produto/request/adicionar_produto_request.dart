import 'package:json_annotation/json_annotation.dart';

part 'adicionar_produto_request.g.dart';

@JsonSerializable()
class AdicionarProdutoRequest {
  final String nomeProduto;
  final String? descricaoProduto;
  final int? unidadeMedidaId;
  final int? grupoId;
  final int? subgrupoId;
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

  AdicionarProdutoRequest({
    required this.nomeProduto,
    this.descricaoProduto,
    this.unidadeMedidaId,
    this.grupoId,
    this.subgrupoId,
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
  });

  factory AdicionarProdutoRequest.fromJson(Map<String, dynamic> json) =>
      _$AdicionarProdutoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AdicionarProdutoRequestToJson(this);
}
