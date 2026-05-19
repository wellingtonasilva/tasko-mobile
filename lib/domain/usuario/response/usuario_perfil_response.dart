import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario_perfil_response.g.dart';

@JsonSerializable()
class UsuarioPerfilResponse extends Equatable {
  final int id;
  final String perfilTipo;
  const UsuarioPerfilResponse({required this.id, required this.perfilTipo});

  factory UsuarioPerfilResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioPerfilResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioPerfilResponseToJson(this);

  @override
  List<Object?> get props => [id, perfilTipo];
}
