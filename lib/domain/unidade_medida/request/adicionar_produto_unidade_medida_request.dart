import 'package:json_annotation/json_annotation.dart';

part 'adicionar_produto_unidade_medida_request.g.dart';

@JsonSerializable()
class AdicionarProdutoUnidadeMedidaRequest {
  final String descricaoUnidadeMedida;

  AdicionarProdutoUnidadeMedidaRequest({required this.descricaoUnidadeMedida});

  factory AdicionarProdutoUnidadeMedidaRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AdicionarProdutoUnidadeMedidaRequestFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AdicionarProdutoUnidadeMedidaRequestToJson(this);
}
