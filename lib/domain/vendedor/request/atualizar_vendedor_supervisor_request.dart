import 'package:json_annotation/json_annotation.dart';

part 'atualizar_vendedor_supervisor_request.g.dart';

@JsonSerializable()
class AtualizarVendedorSupervisorRequest {
  final int id;
  final String nomeSupervisor;

  AtualizarVendedorSupervisorRequest({
    required this.id,
    required this.nomeSupervisor,
  });

  factory AtualizarVendedorSupervisorRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AtualizarVendedorSupervisorRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AtualizarVendedorSupervisorRequestToJson(this);
}
