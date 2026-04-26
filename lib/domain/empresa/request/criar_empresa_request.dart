import 'package:json_annotation/json_annotation.dart';

part 'criar_empresa_request.g.dart';

@JsonSerializable()
class CriarEmpresaRequest {
  final String nomeEmpresa;
  final String email;
  final String senha;

  CriarEmpresaRequest({
    required this.nomeEmpresa,
    required this.email,
    required this.senha,
  });

  factory CriarEmpresaRequest.fromJson(Map<String, dynamic> json) =>
      _$CriarEmpresaRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CriarEmpresaRequestToJson(this);
}
