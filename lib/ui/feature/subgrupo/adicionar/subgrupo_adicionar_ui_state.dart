import 'package:tasko_mobile/domain/subgrupo/request/adicionar_produto_subgrupo2_request.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/util/command.dart';

class SubgrupoAdicionarUiState {
  final Command1<ProdutoSubgrupoResponse, AdicionarProdutoSubgrupoRequest>
  adicionarProdutoSubgrupoCommand;

  SubgrupoAdicionarUiState({required this.adicionarProdutoSubgrupoCommand});

  SubgrupoAdicionarUiState copyWith({
    Command1<ProdutoSubgrupoResponse, AdicionarProdutoSubgrupoRequest>?
    adicionarProdutoSubgrupoCommand,
  }) {
    return SubgrupoAdicionarUiState(
      adicionarProdutoSubgrupoCommand:
          adicionarProdutoSubgrupoCommand ??
          this.adicionarProdutoSubgrupoCommand,
    );
  }
}
