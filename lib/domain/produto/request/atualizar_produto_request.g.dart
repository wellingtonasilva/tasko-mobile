// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atualizar_produto_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AtualizarProdutoRequest _$AtualizarProdutoRequestFromJson(
  Map<String, dynamic> json,
) => AtualizarProdutoRequest(
  id: (json['id'] as num).toInt(),
  nomeProduto: json['nomeProduto'] as String?,
  descricaoProduto: json['descricaoProduto'] as String?,
  unidadeMedidaId: (json['unidadeMedidaId'] as num?)?.toInt(),
  grupoId: (json['grupoId'] as num?)?.toInt(),
  subgrupoId: (json['subgrupoId'] as num?)?.toInt(),
  pesoLiquido: (json['pesoLiquido'] as num?)?.toDouble(),
  marca: json['marca'] as String?,
  fornecedor: json['fornecedor'] as String?,
  aliquotaIcms: (json['aliquotaIcms'] as num?)?.toDouble(),
  aliquotaIpi: (json['aliquotaIpi'] as num?)?.toDouble(),
  dimensaoAltura: (json['dimensaoAltura'] as num?)?.toDouble(),
  dimensaoLargura: (json['dimensaoLargura'] as num?)?.toDouble(),
  dimensaoProfundidade: (json['dimensaoProfundidade'] as num?)?.toDouble(),
  precoCusto: (json['precoCusto'] as num?)?.toDouble(),
  precoSugerido: (json['precoSugerido'] as num?)?.toDouble(),
  margemMinima: (json['margemMinima'] as num?)?.toDouble(),
  quantidadeDisponivel: (json['quantidadeDisponivel'] as num?)?.toDouble(),
  quantidadeReservada: (json['quantidadeReservada'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AtualizarProdutoRequestToJson(
  AtualizarProdutoRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'nomeProduto': instance.nomeProduto,
  'descricaoProduto': instance.descricaoProduto,
  'unidadeMedidaId': instance.unidadeMedidaId,
  'grupoId': instance.grupoId,
  'subgrupoId': instance.subgrupoId,
  'pesoLiquido': instance.pesoLiquido,
  'marca': instance.marca,
  'fornecedor': instance.fornecedor,
  'aliquotaIcms': instance.aliquotaIcms,
  'aliquotaIpi': instance.aliquotaIpi,
  'dimensaoAltura': instance.dimensaoAltura,
  'dimensaoLargura': instance.dimensaoLargura,
  'dimensaoProfundidade': instance.dimensaoProfundidade,
  'precoCusto': instance.precoCusto,
  'precoSugerido': instance.precoSugerido,
  'margemMinima': instance.margemMinima,
  'quantidadeDisponivel': instance.quantidadeDisponivel,
  'quantidadeReservada': instance.quantidadeReservada,
};
