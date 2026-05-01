import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_estoque_localizacao_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ProdutoManterUiState {
  // Produto
  final Command1<ProdutoResponse, int> obterPorIdCommand;
  ProdutoResponse? produto;
  ProdutoGrupoResponse? selectedGrupo;
  ProdutoSubgrupoResponse? selectedSubgrupo;
  ProdutoUnidadeMedidaResponse? selectedUnidadeMedida;

  // Grupo
  final Command0<List<ProdutoGrupoResponse>> listarGrupoCommand;
  List<ProdutoGrupoResponse>? grupos;

  // Subgrupo
  final Command0<List<ProdutoSubgrupoResponse>> listarSubgrupoCommand;
  List<ProdutoSubgrupoResponse>? subgrupos;

  // Unidade Medida
  final Command0<List<ProdutoUnidadeMedidaResponse>> listarUnidadeMedidaCommand;
  List<ProdutoUnidadeMedidaResponse>? unidadesMedida;

  // Código de Barras
  final Command1<List<ProdutoCodigoBarrasResponse>, int>
  listarCodigoBarrasCommand;
  List<ProdutoCodigoBarrasResponse>? codigosBarras;

  //Estoque Localização
  final Command1<List<ProdutoEstoqueLocalizacaoResponse>, int>
  listarEstoqueLocalizacaoCommand;
  List<ProdutoEstoqueLocalizacaoResponse>? estoquesLocalizacao;

  ProdutoManterUiState({
    required this.obterPorIdCommand,
    this.produto,
    this.selectedGrupo,
    this.selectedSubgrupo,
    this.selectedUnidadeMedida,
    required this.listarGrupoCommand,
    this.grupos,
    required this.listarSubgrupoCommand,
    this.subgrupos,
    required this.listarUnidadeMedidaCommand,
    this.unidadesMedida,
    required this.listarCodigoBarrasCommand,
    this.codigosBarras,
    required this.listarEstoqueLocalizacaoCommand,
    this.estoquesLocalizacao,
  });

  ProdutoManterUiState copyWith({
    Command1<ProdutoResponse, int>? obterPorIdCommand,
    ProdutoResponse? produto,
    ProdutoGrupoResponse? selectedGrupo,
    ProdutoSubgrupoResponse? selectedSubgrupo,
    ProdutoUnidadeMedidaResponse? selectedUnidadeMedida,
    Command0<List<ProdutoGrupoResponse>>? listarGrupoCommand,
    List<ProdutoGrupoResponse>? grupos,
    Command0<List<ProdutoSubgrupoResponse>>? listarSubgrupoCommand,
    List<ProdutoSubgrupoResponse>? subgrupos,
    Command0<List<ProdutoUnidadeMedidaResponse>>? listarUnidadeMedidaCommand,
    List<ProdutoUnidadeMedidaResponse>? unidadesMedida,
    Command1<List<ProdutoCodigoBarrasResponse>, int>? listarCodigoBarrasCommand,
    List<ProdutoCodigoBarrasResponse>? codigosBarras,
    Command1<List<ProdutoEstoqueLocalizacaoResponse>, int>?
    listarEstoqueLocalizacaoCommand,
    List<ProdutoEstoqueLocalizacaoResponse>? estoquesLocalizacao,
  }) {
    return ProdutoManterUiState(
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      produto: produto ?? this.produto,
      selectedGrupo: selectedGrupo ?? this.selectedGrupo,
      selectedSubgrupo: selectedSubgrupo ?? this.selectedSubgrupo,
      selectedUnidadeMedida:
          selectedUnidadeMedida ?? this.selectedUnidadeMedida,
      listarGrupoCommand: listarGrupoCommand ?? this.listarGrupoCommand,
      grupos: grupos ?? this.grupos,
      listarSubgrupoCommand:
          listarSubgrupoCommand ?? this.listarSubgrupoCommand,
      subgrupos: subgrupos ?? this.subgrupos,
      listarUnidadeMedidaCommand:
          listarUnidadeMedidaCommand ?? this.listarUnidadeMedidaCommand,
      unidadesMedida: unidadesMedida ?? this.unidadesMedida,
      listarCodigoBarrasCommand:
          listarCodigoBarrasCommand ?? this.listarCodigoBarrasCommand,
      codigosBarras: codigosBarras ?? this.codigosBarras,
      listarEstoqueLocalizacaoCommand:
          listarEstoqueLocalizacaoCommand ??
          this.listarEstoqueLocalizacaoCommand,
      estoquesLocalizacao: estoquesLocalizacao ?? this.estoquesLocalizacao,
    );
  }
}
