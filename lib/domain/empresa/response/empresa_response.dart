import 'package:json_annotation/json_annotation.dart';

part 'empresa_response.g.dart';

@JsonSerializable()
class EmpresaResponse {
  int id;
  String? dominio;
  String nomeEmpresa;
  String? numeroCnpj;
  String email;
  String? logradouro;
  String? numero;
  String? nomeCidade;
  String? nomeBairro;
  String? uf;
  String? numeroTelefone;

  EmpresaResponse({
    required this.id,
    this.dominio,
    required this.nomeEmpresa,
    this.numeroCnpj,
    required this.email,
    this.logradouro,
    this.numero,
    this.nomeCidade,
    this.nomeBairro,
    this.uf,
    this.numeroTelefone,
  });

  factory EmpresaResponse.fromJson(Map<String, dynamic> json) =>
      _$EmpresaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmpresaResponseToJson(this);
}
