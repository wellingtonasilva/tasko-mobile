import 'package:json_annotation/json_annotation.dart';

part 'usuario_perfil_response.g.dart';

@JsonSerializable()
class UsuarioPerfilResponse {
  final int id;
  final String perfilTipo;
  UsuarioPerfilResponse({required this.id, required this.perfilTipo});

  factory UsuarioPerfilResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioPerfilResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioPerfilResponseToJson(this);
}
