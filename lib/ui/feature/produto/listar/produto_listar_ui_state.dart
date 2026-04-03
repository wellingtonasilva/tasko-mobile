import 'package:tasko_mobile/domain/produto/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ProdutoListarUiState {
  final List<ProdutoResponse> produtos;
  final List<ProdutoGrupoResponse> grupos;
  final int? grupoSelecionadoId;
  final String termoBusca;
  final Command0 listarProdutosCommand;
  final Command0 carregarGruposCommand;

  ProdutoListarUiState({
    required this.produtos,
    required this.grupos,
    required this.grupoSelecionadoId,
    required this.termoBusca,
    required this.listarProdutosCommand,
    required this.carregarGruposCommand,
  });

  ProdutoListarUiState copyWith({
    List<ProdutoResponse>? produtos,
    List<ProdutoGrupoResponse>? grupos,
    int? grupoSelecionadoId,
    bool limparGrupoSelecionado = false,
    String? termoBusca,
    Command0? listarProdutosCommand,
    Command0? carregarGruposCommand,
  }) {
    return ProdutoListarUiState(
      produtos: produtos ?? this.produtos,
      grupos: grupos ?? this.grupos,
      grupoSelecionadoId: limparGrupoSelecionado
          ? null
          : (grupoSelecionadoId ?? this.grupoSelecionadoId),
      termoBusca: termoBusca ?? this.termoBusca,
      listarProdutosCommand:
          listarProdutosCommand ?? this.listarProdutosCommand,
      carregarGruposCommand:
          carregarGruposCommand ?? this.carregarGruposCommand,
    );
  }
}
