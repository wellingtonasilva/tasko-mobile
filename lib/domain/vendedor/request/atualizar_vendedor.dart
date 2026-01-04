import 'package:json_annotation/json_annotation.dart';

part 'atualizar_vendedor.g.dart';

@JsonSerializable()
class AtualizarVendedorRequest {
  final int id;
  final String codigoVendedor;
  final String nomeVendedor;
  final String numeroCPF;
  final String email;
  final String numeroTelefone;
  final double valorMetaMensal;
  final double percentualComissao;
  final DateTime ultimoSincronismo;
  final String codigoDispositivo;
  final int supervisorId;
  final int territorioId;

  AtualizarVendedorRequest({
    required this.id,
    required this.codigoVendedor,
    required this.nomeVendedor,
    required this.numeroCPF,
    required this.email,
    required this.numeroTelefone,
    required this.valorMetaMensal,
    required this.percentualComissao,
    required this.ultimoSincronismo,
    required this.codigoDispositivo,
    required this.supervisorId,
    required this.territorioId,
  });

  factory AtualizarVendedorRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarVendedorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AtualizarVendedorRequestToJson(this);
}
