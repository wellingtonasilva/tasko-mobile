import 'package:json_annotation/json_annotation.dart';

part 'adicionar_vendedor_territorio_request.g.dart';

@JsonSerializable()
class AdicionarVendedorTerritorioRequest {
  final String nomeTerritorio;
  final String descricaoTerritorio;
  final String nomeRegiao;
  final String estado;
  final String coordenadasPoligono;
  final int supervisorId;

  AdicionarVendedorTerritorioRequest({
    required this.nomeTerritorio,
    required this.descricaoTerritorio,
    required this.nomeRegiao,
    required this.estado,
    required this.coordenadasPoligono,
    required this.supervisorId,
  });

  factory AdicionarVendedorTerritorioRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AdicionarVendedorTerritorioRequestFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AdicionarVendedorTerritorioRequestToJson(this);
}
