import 'package:json_annotation/json_annotation.dart';

part 'atualizar_vendedor_territorio_request.g.dart';

@JsonSerializable()
class AtualizarVendedorTerritorioRequest {
  final int id;
  final String nomeTerritorio;
  final String descricaoTerritorio;
  final String nomeRegiao;
  final String estado;
  final String coordenadasPoligono;
  final int supervisorId;

  AtualizarVendedorTerritorioRequest({
    required this.id,
    required this.nomeTerritorio,
    required this.descricaoTerritorio,
    required this.nomeRegiao,
    required this.estado,
    required this.coordenadasPoligono,
    required this.supervisorId,
  });

  factory AtualizarVendedorTerritorioRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AtualizarVendedorTerritorioRequestFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AtualizarVendedorTerritorioRequestToJson(this);
}
