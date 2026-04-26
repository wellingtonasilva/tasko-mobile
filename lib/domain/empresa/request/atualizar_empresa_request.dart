import 'package:json_annotation/json_annotation.dart';

part 'atualizar_empresa_request.g.dart';

@JsonSerializable()
class AtualizarEmpresaRequest {
  final int id;
  final String nomeEmpresa;
  final String email;
  final String logradouro;
  final String numero;
  final String nomeCidade;
  final String nomeBairro;
  final String uf;
  final String numeroTelefone;

  AtualizarEmpresaRequest({
    required this.id,
    required this.nomeEmpresa,
    required this.email,
    required this.logradouro,
    required this.numero,
    required this.nomeCidade,
    required this.nomeBairro,
    required this.uf,
    required this.numeroTelefone,
  });

  factory AtualizarEmpresaRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarEmpresaRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AtualizarEmpresaRequestToJson(this);
}
