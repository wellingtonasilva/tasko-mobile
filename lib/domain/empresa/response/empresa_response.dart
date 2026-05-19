import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'empresa_response.g.dart';

@JsonSerializable()
class EmpresaResponse extends Equatable {
  final int id;
  final String? dominio;
  final String nomeEmpresa;
  final String? numeroCnpj;
  final String email;
  final String? logradouro;
  final String? numero;
  final String? nomeCidade;
  final String? nomeBairro;
  final String? uf;
  final String? numeroTelefone;

  const EmpresaResponse({
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

  @override
  List<Object?> get props => [
    id,
    dominio,
    nomeEmpresa,
    numeroCnpj,
    email,
    logradouro,
    numero,
    nomeCidade,
    nomeBairro,
    uf,
    numeroTelefone,
  ];
}
