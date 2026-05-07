import 'package:json_annotation/json_annotation.dart';

part 'atualizar_vendedor.g.dart';

@JsonSerializable()
class AtualizarVendedorRequest {
  final int id;
  final int empresaId;
  final String codigoVendedor;
  final String nomeVendedor;
  final String numeroCPF;
  final String email;
  final String numeroTelefone;
  final double valorMetaMensal;
  final double percentualComissao;
  final String? codigoDispositivo;
  final int? supervisorId;
  final int? territorioId;
  final bool indicadorAtivo;

  AtualizarVendedorRequest({
    required this.id,
    required this.empresaId,
    required this.codigoVendedor,
    required this.nomeVendedor,
    required this.numeroCPF,
    required this.email,
    required this.numeroTelefone,
    required this.valorMetaMensal,
    required this.percentualComissao,
    this.codigoDispositivo,
    this.supervisorId,
    this.territorioId,
    required this.indicadorAtivo,
  });

  factory AtualizarVendedorRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarVendedorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AtualizarVendedorRequestToJson(this);
}
