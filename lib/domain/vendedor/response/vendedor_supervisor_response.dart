import 'package:json_annotation/json_annotation.dart';

part 'vendedor_supervisor_response.g.dart';

@JsonSerializable()
class VendedorSupervisorResponse {
  final int id;
  final String? nomeSupervisor;

  VendedorSupervisorResponse({required this.id, this.nomeSupervisor});

  factory VendedorSupervisorResponse.fromJson(Map<String, dynamic> json) =>
      _$VendedorSupervisorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VendedorSupervisorResponseToJson(this);
}
