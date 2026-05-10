import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/request/adicionar_produto_request.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/domain/unidade_medida/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ProdutoAdicionarUiState {
  static const Object _unset = Object();

  ProdutoResponse? produtoDraft;
  final Command1<ProdutoResponse, AdicionarProdutoRequest> adicionarCommand;
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

  ProdutoAdicionarUiState({
    this.produtoDraft,
    required this.adicionarCommand,
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

  ProdutoAdicionarUiState copyWith({
    Object? produtoDraft = _unset,
    Command1<ProdutoResponse, AdicionarProdutoRequest>? adicionarCommand,
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
    return ProdutoAdicionarUiState(
      produtoDraft: identical(produtoDraft, _unset)
          ? this.produtoDraft
          : produtoDraft as ProdutoResponse?,
      adicionarCommand: adicionarCommand ?? this.adicionarCommand,
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
