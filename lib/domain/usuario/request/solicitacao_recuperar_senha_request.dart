import 'package:json_annotation/json_annotation.dart';

part 'solicitacao_recuperar_senha_request.g.dart';

@JsonSerializable()
class SolicitacaoRecuperarSenhaRequest {
  final String email;

  SolicitacaoRecuperarSenhaRequest({required this.email});

  factory SolicitacaoRecuperarSenhaRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$SolicitacaoRecuperarSenhaRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SolicitacaoRecuperarSenhaRequestToJson(this);
}
