import 'package:json_annotation/json_annotation.dart';

part 'atualizar_produto_request.g.dart';

@JsonSerializable()
class AtualizarProdutoRequest {
  int id;
  String? nomeProduto;
  String? descricaoProduto;
  int? unidadeMedidaId;
  int? grupoId;
  int? subgrupoId;
  double? pesoLiquido;
  String? marca;
  String? fornecedor;
  double? aliquotaIcms;
  double? aliquotaIpi;
  double? dimensaoAltura;
  double? dimensaoLargura;
  double? dimensaoProfundidade;
  double? precoCusto;
  double? precoSugerido;
  double? margemMinima;
  double? quantidadeDisponivel;
  double? quantidadeReservada;

  AtualizarProdutoRequest({
    required this.id,
    this.nomeProduto,
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

  factory AtualizarProdutoRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarProdutoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AtualizarProdutoRequestToJson(this);
}
