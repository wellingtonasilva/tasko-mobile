import 'package:json_annotation/json_annotation.dart';

part 'atualizar_usuario_request.g.dart';

@JsonSerializable()
class AtualizarUsuarioRequest {
  final int id;
  final String nomeUsuario;
  final String? nomeCompleto;
  final String? numeroTelefone;
  final int? vendedorId;
  final bool? indicadorAtivo;

  AtualizarUsuarioRequest({
    required this.id,
    required this.nomeUsuario,
    this.nomeCompleto,
    this.numeroTelefone,
    this.vendedorId,
    this.indicadorAtivo,
  });

  factory AtualizarUsuarioRequest.fromJson(Map<String, dynamic> json) =>
      _$AtualizarUsuarioRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AtualizarUsuarioRequestToJson(this);
}
