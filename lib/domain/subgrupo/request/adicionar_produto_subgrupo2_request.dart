import 'package:json_annotation/json_annotation.dart';

part 'adicionar_produto_subgrupo2_request.g.dart';

//TODO Verificar o erro no nome do arquivo/classe
@JsonSerializable()
class AdicionarProdutoSubgrupoRequest {
  String descricaoSubgrupo;

  AdicionarProdutoSubgrupoRequest({required this.descricaoSubgrupo});

  factory AdicionarProdutoSubgrupoRequest.fromJson(Map<String, dynamic> json) =>
      _$AdicionarProdutoSubgrupoRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AdicionarProdutoSubgrupoRequestToJson(this);
}
