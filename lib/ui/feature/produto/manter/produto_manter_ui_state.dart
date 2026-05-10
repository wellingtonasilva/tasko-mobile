import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/request/atualizar_produto_request.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/domain/unidade_medida/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ProdutoManterUiState {
  static const Object _unset = Object();

  ProdutoResponse? produto;
  ProdutoResponse? produtoDraft;
  final Command1<ProdutoResponse, (int id,)> obterPorIdCommand;
  final Command1<ProdutoResponse, (int id, AtualizarProdutoRequest request)>
  atualizarCommand;

  // Unidade de Medida
  final Command0<void> listarUnidadeMedidaCommand;
  List<ProdutoUnidadeMedidaResponse>? unidadesMedida;
  ProdutoUnidadeMedidaResponse? selectedUnidadeMedida;

  // Grupo
  final Command0<void> listarGrupoCommand;
  List<ProdutoGrupoResponse>? grupos;
  ProdutoGrupoResponse? selectedGrupo;

  // Subgrupo
  final Command0<void> listarSubgrupoCommand;
  List<ProdutoSubgrupoResponse>? subgrupos;
  ProdutoSubgrupoResponse? selectedSubgrupo;

  ProdutoManterUiState({
    this.produto,
    this.produtoDraft,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
    required this.listarUnidadeMedidaCommand,
    this.unidadesMedida,
    this.selectedUnidadeMedida,
    required this.listarGrupoCommand,
    this.grupos,
    this.selectedGrupo,
    required this.listarSubgrupoCommand,
    this.subgrupos,
    this.selectedSubgrupo,
  });

  ProdutoManterUiState copyWith({
    Object? produto = _unset,
    Object? produtoDraft = _unset,
    Command1<ProdutoResponse, (int id,)>? obterPorIdCommand,
    Command1<ProdutoResponse, (int id, AtualizarProdutoRequest request)>?
    atualizarCommand,
    Command0<void>? listarUnidadeMedidaCommand,
    List<ProdutoUnidadeMedidaResponse>? unidadesMedida,
    Object? selectedUnidadeMedida = _unset,
    Command0<void>? listarGrupoCommand,
    List<ProdutoGrupoResponse>? grupos,
    Object? selectedGrupo = _unset,
    Command0<void>? listarSubgrupoCommand,
    List<ProdutoSubgrupoResponse>? subgrupos,
    Object? selectedSubgrupo = _unset,
  }) {
    return ProdutoManterUiState(
      produto: identical(produto, _unset)
          ? this.produto
          : produto as ProdutoResponse?,
      produtoDraft: identical(produtoDraft, _unset)
          ? this.produtoDraft
          : produtoDraft as ProdutoResponse?,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
      listarUnidadeMedidaCommand:
          listarUnidadeMedidaCommand ?? this.listarUnidadeMedidaCommand,
      unidadesMedida: unidadesMedida ?? this.unidadesMedida,
      selectedUnidadeMedida: identical(selectedUnidadeMedida, _unset)
          ? this.selectedUnidadeMedida
          : selectedUnidadeMedida as ProdutoUnidadeMedidaResponse?,
      listarGrupoCommand: listarGrupoCommand ?? this.listarGrupoCommand,
      grupos: grupos ?? this.grupos,
      selectedGrupo: identical(selectedGrupo, _unset)
          ? this.selectedGrupo
          : selectedGrupo as ProdutoGrupoResponse?,
      listarSubgrupoCommand:
          listarSubgrupoCommand ?? this.listarSubgrupoCommand,
      subgrupos: subgrupos ?? this.subgrupos,
      selectedSubgrupo: identical(selectedSubgrupo, _unset)
          ? this.selectedSubgrupo
          : selectedSubgrupo as ProdutoSubgrupoResponse?,
    );
  }
}
