import 'package:json_annotation/json_annotation.dart';

part 'usuario_empresa_response.g.dart';

@JsonSerializable()
class UsuarioEmpresaResponse {
  final int id;
  final int empresaId;

  UsuarioEmpresaResponse({required this.id, required this.empresaId});

  factory UsuarioEmpresaResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioEmpresaResponseFromJson(json);
}
