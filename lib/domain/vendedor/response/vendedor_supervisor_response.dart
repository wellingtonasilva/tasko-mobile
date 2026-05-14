import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendedor_supervisor_response.g.dart';

@JsonSerializable()
class VendedorSupervisorResponse extends Equatable {
  final int id;
  final String? nomeSupervisor;

  const VendedorSupervisorResponse({required this.id, this.nomeSupervisor});

  @override
  List<Object?> get props => [id, nomeSupervisor];

  factory VendedorSupervisorResponse.fromJson(Map<String, dynamic> json) =>
      _$VendedorSupervisorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VendedorSupervisorResponseToJson(this);
}
