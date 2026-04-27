import 'package:json_annotation/json_annotation.dart';

part 'adicionar_usuario_request.g.dart';

@JsonSerializable()
class AdicionarUsuarioRequest {
  final String nomeUsuario;
  final String senha;
  final int vendedorId;

  AdicionarUsuarioRequest({
    required this.nomeUsuario,
    required this.senha,
    required this.vendedorId,
  });

  factory AdicionarUsuarioRequest.fromJson(Map<String, dynamic> json) =>
      _$AdicionarUsuarioRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AdicionarUsuarioRequestToJson(this);
}
