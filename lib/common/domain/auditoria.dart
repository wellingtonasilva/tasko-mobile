import 'package:json_annotation/json_annotation.dart';

part 'auditoria.g.dart';

@JsonSerializable()
class Auditoria {
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;
  final bool? indicadorAtivo;

  Auditoria({this.criadoEm, this.atualizadoEm, this.indicadorAtivo});

  factory Auditoria.fromJson(Map<String, dynamic> json) =>
      _$AuditoriaFromJson(json);
  Map<String, dynamic> toJson() => _$AuditoriaToJson(this);
}
