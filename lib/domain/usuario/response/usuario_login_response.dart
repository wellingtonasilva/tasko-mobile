import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_empresa_response.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_perfil_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

part 'usuario_login_response.g.dart';

@JsonSerializable()
class UsuarioLoginResponse extends Equatable {
  final int id;
  final VendedorResponse? vendedor;
  final String nomeUsuario;
  final String token;
  @JsonKey(defaultValue: <UsuarioPerfilResponse>[])
  final List<UsuarioPerfilResponse>? perfis;
  @JsonKey(defaultValue: <UsuarioEmpresaResponse>[])
  final List<UsuarioEmpresaResponse>? empresas;

  const UsuarioLoginResponse({
    required this.id,
    this.vendedor,
    required this.nomeUsuario,
    required this.token,
    this.perfis,
    this.empresas,
  });

  factory UsuarioLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioLoginResponseToJson(this);

  @override
  List<Object?> get props => [
    id,
    vendedor,
    nomeUsuario,
    token,
    perfis,
    empresas,
  ];
}
