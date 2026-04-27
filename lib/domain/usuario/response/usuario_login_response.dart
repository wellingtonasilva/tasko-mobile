import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_empresa_response.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_perfil_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

part 'usuario_login_response.g.dart';

@JsonSerializable()
class UsuarioLoginResponse {
  final int id;
  final VendedorResponse? vendedor;
  final String nomeUsuario;
  final String token;
  final List<UsuarioPerfilResponse> perfis;
  final List<UsuarioEmpresaResponse> empresas;

  UsuarioLoginResponse({
    required this.id,
    this.vendedor,
    required this.nomeUsuario,
    required this.token,
    required this.perfis,
    required this.empresas,
  });

  factory UsuarioLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioLoginResponseFromJson(json);
}
