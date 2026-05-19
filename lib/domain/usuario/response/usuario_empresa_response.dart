import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario_empresa_response.g.dart';

@JsonSerializable()
class UsuarioEmpresaResponse extends Equatable {
  final int id;
  final int empresaId;

  const UsuarioEmpresaResponse({required this.id, required this.empresaId});

  factory UsuarioEmpresaResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioEmpresaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioEmpresaResponseToJson(this);

  @override
  List<Object?> get props => [id, empresaId];
}
