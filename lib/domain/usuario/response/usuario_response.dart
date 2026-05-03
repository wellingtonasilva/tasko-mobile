import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_perfil_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

part 'usuario_response.g.dart';

@JsonSerializable()
class UsuarioResponse {
  final int id;
  final String nomeUsuario;
  final VendedorResponse? vendedor;
  final Auditoria auditoria;
  final List<UsuarioPerfilResponse> perfis;

  UsuarioResponse({
    required this.id,
    required this.nomeUsuario,
    this.vendedor,
    required this.auditoria,
    required this.perfis,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioResponseToJson(this);
}
