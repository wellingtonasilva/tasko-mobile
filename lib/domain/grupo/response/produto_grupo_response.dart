import 'package:equatable/equatable.dart';

class ProdutoGrupoResponse extends Equatable {
  final int id;
  final String descricaoGrupo;

  const ProdutoGrupoResponse({required this.id, required this.descricaoGrupo});

  factory ProdutoGrupoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoGrupoResponse(
      id: _toInt(json['id']) ?? 0,
      descricaoGrupo: (json['descricaoGrupo'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'descricaoGrupo': descricaoGrupo};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdutoGrupoResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          descricaoGrupo == other.descricaoGrupo;

  @override
  int get hashCode => id.hashCode ^ descricaoGrupo.hashCode;

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  @override
  List<Object?> get props => [id, descricaoGrupo];
}
