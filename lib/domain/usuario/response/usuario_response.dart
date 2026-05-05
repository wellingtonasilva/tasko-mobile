import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_perfil_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

part 'usuario_response.g.dart';

@JsonSerializable()
class UsuarioResponse {
  final int id;
  final String nomeUsuario;
  final String? nomeCompleto;
  final String? numeroTelefone;
  final VendedorResponse? vendedor;
  final Auditoria auditoria;
  final List<UsuarioPerfilResponse> perfis;

  UsuarioResponse({
    required this.id,
    required this.nomeUsuario,
    this.nomeCompleto,
    this.numeroTelefone,
    this.vendedor,
    required this.auditoria,
    required this.perfis,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioResponseToJson(this);
}
