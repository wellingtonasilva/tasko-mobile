import 'package:tasko_mobile/domain/subgrupo/request/atualizar_produto_subgrupo_request.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/util/command.dart';

class SubgrupoManterUiState {
  ProdutoSubgrupoResponse? subgrupo;
  final Command1<ProdutoSubgrupoResponse, (int id,)> obterPorIdCommand;
  final Command1<
    ProdutoSubgrupoResponse,
    (int id, AtualizarProdutoSubgrupoRequest request)
  >
  atualizarCommand;

  SubgrupoManterUiState({
    this.subgrupo,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
  });

  SubgrupoManterUiState copyWith({
    ProdutoSubgrupoResponse? subgrupo,
    Command1<ProdutoSubgrupoResponse, (int id,)>? obterPorIdCommand,
    Command1<
      ProdutoSubgrupoResponse,
      (int id, AtualizarProdutoSubgrupoRequest request)
    >?
    atualizarCommand,
  }) {
    return SubgrupoManterUiState(
      subgrupo: subgrupo ?? this.subgrupo,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
    );
  }
}
