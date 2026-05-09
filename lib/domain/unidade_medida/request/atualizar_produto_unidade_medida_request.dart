import 'package:json_annotation/json_annotation.dart';

part 'atualizar_produto_unidade_medida_request.g.dart';

@JsonSerializable()
class AtualizarProdutoUnidadeMedidaRequest {
  final int id;
  final String descricaoUnidadeMedida;

  AtualizarProdutoUnidadeMedidaRequest({
    required this.id,
    required this.descricaoUnidadeMedida,
  });

  factory AtualizarProdutoUnidadeMedidaRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AtualizarProdutoUnidadeMedidaRequestFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AtualizarProdutoUnidadeMedidaRequestToJson(this);
}
