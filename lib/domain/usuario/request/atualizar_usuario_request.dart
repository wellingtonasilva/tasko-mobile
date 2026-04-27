import 'package:json_annotation/json_annotation.dart';

part 'atualizar_usuario_request.g.dart';

@JsonSerializable()
class AtualizarUsuarioRequest {
  final int id;
  final String nomeUsuario;
  final String senha;
  final int vendedorId;

  AtualizarUsuarioRequest({
    required this.id,
    required this.nomeUsuario,
    required this.senha,
    required this.vendedorId,
  });

  factory AtualizarUsuarioRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarUsuarioRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AtualizarUsuarioRequestToJson(this);
}
