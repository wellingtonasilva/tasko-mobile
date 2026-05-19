import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';

part 'vendedor_territorio_response.g.dart';

@JsonSerializable()
class VendedorTerritorioResponse extends Equatable {
  final int id;
  final String? nomeTerritorio;
  final String? descricaoTerritorio;
  final String? nomeRegiao;
  final String? estado;
  final String? coordenadasPoligono;
  final VendedorSupervisorResponse? supervisor;
  final Auditoria? auditoria;

  const VendedorTerritorioResponse({
    required this.id,
    this.nomeTerritorio,
    this.descricaoTerritorio,
    this.nomeRegiao,
    this.estado,
    this.coordenadasPoligono,
    this.supervisor,
    this.auditoria,
  });

  factory VendedorTerritorioResponse.fromJson(Map<String, dynamic> json) =>
      _$VendedorTerritorioResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VendedorTerritorioResponseToJson(this);

  @override
  List<Object?> get props => [
    id,
    nomeTerritorio,
    descricaoTerritorio,
    nomeRegiao,
    estado,
    coordenadasPoligono,
    supervisor,
    auditoria,
  ];
}
