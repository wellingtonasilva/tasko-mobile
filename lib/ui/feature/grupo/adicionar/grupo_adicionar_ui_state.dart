import 'package:tasko_mobile/domain/grupo/request/adicionar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/util/command.dart';

class GrupoAdicionarUiState {
  final Command1<ProdutoGrupoResponse, AdicionarProdutoGrupoRequest>
  adicionarProdutoGrupoCommand;

  GrupoAdicionarUiState({required this.adicionarProdutoGrupoCommand});

  GrupoAdicionarUiState copyWith({
    Command1<ProdutoGrupoResponse, AdicionarProdutoGrupoRequest>?
    adicionarProdutoGrupoCommand,
  }) {
    return GrupoAdicionarUiState(
      adicionarProdutoGrupoCommand:
          adicionarProdutoGrupoCommand ?? this.adicionarProdutoGrupoCommand,
    );
  }
}
