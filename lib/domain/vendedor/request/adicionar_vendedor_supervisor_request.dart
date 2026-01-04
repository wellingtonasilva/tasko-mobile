import 'package:json_annotation/json_annotation.dart';

part 'adicionar_vendedor_supervisor_request.g.dart';

@JsonSerializable()
class AdicionarVendedorSupervisorRequest {
  final String nomeSupervisor;

  AdicionarVendedorSupervisorRequest({required this.nomeSupervisor});

  factory AdicionarVendedorSupervisorRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$AdicionarVendedorSupervisorRequestFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AdicionarVendedorSupervisorRequestToJson(this);
}
