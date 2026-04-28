import 'package:json_annotation/json_annotation.dart';

part 'resetar_senha_request.g.dart';

@JsonSerializable()
class ResetarSenhaRequest {
  final String token;
  final String novaSenha;

  ResetarSenhaRequest({required this.token, required this.novaSenha});

  factory ResetarSenhaRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetarSenhaRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ResetarSenhaRequestToJson(this);
}
