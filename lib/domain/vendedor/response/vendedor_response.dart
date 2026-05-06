import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';

part 'vendedor_response.g.dart';

@JsonSerializable()
class VendedorResponse {
  final int id;
  final int empresaId;
  final String? codigoVendedor;
  final String? nomeVendedor;
  final String? numeroCPF;
  final String? email;
  final String? numeroTelefone;
  final double? valorMetaMensal;
  final double? percentualComissao;
  final DateTime? ultimoSincronismo;
  final String? codigoDispositivo;
  final VendedorSupervisorResponse? supervisor;
  final VendedorTerritorioResponse? territorio;
  final Auditoria? auditoria;

  VendedorResponse({
    required this.id,
    required this.empresaId,
    this.codigoVendedor,
    this.nomeVendedor,
    this.numeroCPF,
    this.email,
    this.numeroTelefone,
    this.valorMetaMensal,
    this.percentualComissao,
    this.ultimoSincronismo,
    this.codigoDispositivo,
    this.supervisor,
    this.territorio,
    this.auditoria,
  });

  factory VendedorResponse.fromJson(Map<String, dynamic> json) =>
      _$VendedorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VendedorResponseToJson(this);
}
