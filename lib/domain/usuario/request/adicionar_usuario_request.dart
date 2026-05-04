import 'package:json_annotation/json_annotation.dart';

part 'adicionar_usuario_request.g.dart';

@JsonSerializable()
class AdicionarUsuarioRequest {
  final String? nomeCompleto;
  final String? numeroTelefone;
  final String nomeUsuario;
  final String senha;
  final int? vendedorId;

  AdicionarUsuarioRequest({
    this.nomeCompleto,
    this.numeroTelefone,
    required this.nomeUsuario,
    required this.senha,
    this.vendedorId,
  });

  factory AdicionarUsuarioRequest.fromJson(Map<String, dynamic> json) =>
      _$AdicionarUsuarioRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AdicionarUsuarioRequestToJson(this);
}
