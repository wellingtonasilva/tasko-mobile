import 'package:json_annotation/json_annotation.dart';

part 'atualizar_produto_subgrupo_request.g.dart';

@JsonSerializable()
class AtualizarProdutoSubgrupoRequest {
  int id;
  int? empresaId;
  String descricaoSubgrupo;

  AtualizarProdutoSubgrupoRequest({
    required this.id,
    this.empresaId,
    required this.descricaoSubgrupo,
  });

  factory AtualizarProdutoSubgrupoRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarProdutoSubgrupoRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AtualizarProdutoSubgrupoRequestToJson(this);
}
