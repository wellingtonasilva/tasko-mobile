import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/util/command.dart';

class SubgrupoListarUiState {
  final List<ProdutoSubgrupoResponse> subgrupos;
  final Command0 listarSubgruposCommand;
  final Command1 excluirSubgrupoCommand;

  SubgrupoListarUiState({
    required this.subgrupos,
    required this.listarSubgruposCommand,
    required this.excluirSubgrupoCommand,
  });

  SubgrupoListarUiState copyWith({
    List<ProdutoSubgrupoResponse>? subgrupos,
    Command0? listarSubgruposCommand,
    Command1? excluirSubgrupoCommand,
  }) {
    return SubgrupoListarUiState(
      subgrupos: subgrupos ?? this.subgrupos,
      listarSubgruposCommand:
          listarSubgruposCommand ?? this.listarSubgruposCommand,
      excluirSubgrupoCommand:
          excluirSubgrupoCommand ?? this.excluirSubgrupoCommand,
    );
  }
}
