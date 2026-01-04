import 'package:json_annotation/json_annotation.dart';

part 'adicionar_vendedor_request.g.dart';

@JsonSerializable()
class AdicionarVendedorRequest {
  final String codigoVendedor;
  final String nomeVendedor;
  final String numeroCPF;
  final String email;
  final String numeroTelefone;
  final double valorMetaMensal;
  final double percentualComissao;
  final int supervisorId;
  final int territorioId;

  AdicionarVendedorRequest({
    required this.codigoVendedor,
    required this.nomeVendedor,
    required this.numeroCPF,
    required this.email,
    required this.numeroTelefone,
    required this.valorMetaMensal,
    required this.percentualComissao,
    required this.supervisorId,
    required this.territorioId,
  });

  factory AdicionarVendedorRequest.fromJson(Map<String, dynamic> json) =>
      _$AdicionarVendedorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AdicionarVendedorRequestToJson(this);
}
