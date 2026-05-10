import 'package:tasko_mobile/domain/grupo/request/atualizar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/util/command.dart';

class GrupoManterUiState {
  ProdutoGrupoResponse? grupo;
  final Command1<ProdutoGrupoResponse, (int id,)> obterPorIdCommand;
  final Command1<
    ProdutoGrupoResponse,
    (int id, AtualizarProdutoGrupoRequest request)
  >
  atualizarCommand;

  GrupoManterUiState({
    this.grupo,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
  });

  GrupoManterUiState copyWith({
    ProdutoGrupoResponse? grupo,
    Command1<ProdutoGrupoResponse, (int id,)>? obterPorIdCommand,
    Command1<
      ProdutoGrupoResponse,
      (int id, AtualizarProdutoGrupoRequest request)
    >?
    atualizarCommand,
  }) {
    return GrupoManterUiState(
      grupo: grupo ?? this.grupo,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
    );
  }
}
