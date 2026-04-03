class ProdutoSubgrupoResponse {
  final int id;
  final int? grupoId;
  final String nome;

  ProdutoSubgrupoResponse({required this.id, this.grupoId, required this.nome});

  factory ProdutoSubgrupoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoSubgrupoResponse(
      id: _toInt(json['id']) ?? 0,
      grupoId: _toInt(json['grupoId']),
      nome: (json['nome'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'grupoId': grupoId, 'nome': nome};
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
