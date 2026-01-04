// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditoria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auditoria _$AuditoriaFromJson(Map<String, dynamic> json) => Auditoria(
  criadoEm: json['criadoEm'] == null
      ? null
      : DateTime.parse(json['criadoEm'] as String),
  atualizadoEm: json['atualizadoEm'] == null
      ? null
      : DateTime.parse(json['atualizadoEm'] as String),
  indicadorAtivo: json['indicadorAtivo'] as bool?,
);

Map<String, dynamic> _$AuditoriaToJson(Auditoria instance) => <String, dynamic>{
  'criadoEm': instance.criadoEm?.toIso8601String(),
  'atualizadoEm': instance.atualizadoEm?.toIso8601String(),
  'indicadorAtivo': instance.indicadorAtivo,
};
