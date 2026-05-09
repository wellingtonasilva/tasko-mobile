import 'package:json_annotation/json_annotation.dart';

part 'adicionar_produto_grupo_request.g.dart';

@JsonSerializable()
class AdicionarProdutoGrupoRequest {
  String descricaoGrupo;

  AdicionarProdutoGrupoRequest({required this.descricaoGrupo});

  factory AdicionarProdutoGrupoRequest.fromJson(Map<String, dynamic> json) =>
      _$AdicionarProdutoGrupoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AdicionarProdutoGrupoRequestToJson(this);
}
