import 'package:json_annotation/json_annotation.dart';
import 'package:tasko_mobile/common/domain/auditoria.dart';

part 'vendedor_supervisor_response.g.dart';

@JsonSerializable()
class VendedorSupervisorResponse {
  final int id;
  final String nomeSupervisor;
  final Auditoria auditoria;

  VendedorSupervisorResponse({
    required this.id,
    required this.nomeSupervisor,
    required this.auditoria,
  });

  factory VendedorSupervisorResponse.fromJson(Map<String, dynamic> json) =>
      _$VendedorSupervisorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VendedorSupervisorResponseToJson(this);
}
