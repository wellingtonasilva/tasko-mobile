import 'package:json_annotation/json_annotation.dart';

part 'atualizar_produto_grupo_request.g.dart';

@JsonSerializable()
class AtualizarProdutoGrupoRequest {
  final int id;
  final String descricaoGrupo;

  AtualizarProdutoGrupoRequest({
    required this.id,
    required this.descricaoGrupo,
  });

  factory AtualizarProdutoGrupoRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarProdutoGrupoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AtualizarProdutoGrupoRequestToJson(this);
}
