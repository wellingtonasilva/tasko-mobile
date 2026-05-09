import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/util/command.dart';

class GrupoListarUiState {
  final List<ProdutoGrupoResponse> grupos;
  final Command0 listarGruposCommand;
  final Command1 excluirGrupoCommand;

  GrupoListarUiState({
    required this.grupos,
    required this.listarGruposCommand,
    required this.excluirGrupoCommand,
  });

  GrupoListarUiState copyWith({
    List<ProdutoGrupoResponse>? grupos,
    Command0? listarGruposCommand,
    Command1? excluirGrupoCommand,
  }) {
    return GrupoListarUiState(
      grupos: grupos ?? this.grupos,
      listarGruposCommand: listarGruposCommand ?? this.listarGruposCommand,
      excluirGrupoCommand: excluirGrupoCommand ?? this.excluirGrupoCommand,
    );
  }
}
