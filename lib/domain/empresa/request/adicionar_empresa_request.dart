import 'package:json_annotation/json_annotation.dart';

part 'adicionar_empresa_request.g.dart';

@JsonSerializable()
class AdicionarEmpresaRequest {
  final String dominio;
  final String nomeEmpresa;
  final String numeroCnpj;
  final String email;
  final String logradouro;
  final String numero;
  final String nomeCidade;
  final String nomeBairro;
  final String uf;
  final String numeroTelefone;

  AdicionarEmpresaRequest({
    required this.dominio,
    required this.nomeEmpresa,
    required this.numeroCnpj,
    required this.email,
    required this.logradouro,
    required this.numero,
    required this.nomeCidade,
    required this.nomeBairro,
    required this.uf,
    required this.numeroTelefone,
  });

  factory AdicionarEmpresaRequest.fromJson(Map<String, dynamic> json) =>
      _$AdicionarEmpresaRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AdicionarEmpresaRequestToJson(this);
}
