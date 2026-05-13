import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_hybrid.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/request/adicionar_produto_request.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/domain/unidade_medida/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/ui/feature/produto/adicionar/produto_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoAdicionarViewModel extends Notifier<ProdutoAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  ProdutoAdicionarUiState build() {
    return ProdutoAdicionarUiState(
      adicionarCommand: Command1<ProdutoResponse, AdicionarProdutoRequest>(
        (request) => _adicionarProduto(request),
      ),
      listarUnidadeMedidaCommand: Command0<void>(
        () => _listarProdutoUnidadeMedida(),
      ),
      listarGrupoCommand: Command0<void>(() => _listarProdutoGrupo()),
      listarSubgrupoCommand: Command0<void>(() => _listarProdutoSubgrupo()),
    );
  }

  Future<void> enviarResumo() async {
    onStartEvent?.call();
    final draft = state.produtoDraft;
    if (draft == null) return;

    final request = AdicionarProdutoRequest(
      nomeProduto: draft.nomeProduto ?? '',
      descricaoProduto: draft.descricaoProduto,
      marca: draft.marca,
      fornecedor: draft.fornecedor,
      unidadeMedidaId: draft.unidadeMedidaId,
      grupoId: draft.grupoId,
      subgrupoId: draft.subgrupoId,
      precoCusto: draft.precoCusto,
      precoSugerido: draft.precoSugerido,
      margemMinima: draft.margemMinima,
      aliquotaIcms: draft.aliquotaIcms,
      aliquotaIpi: draft.aliquotaIpi,
      quantidadeDisponivel: draft.quantidadeDisponivel,
      quantidadeReservada: draft.quantidadeReservada,
      pesoLiquido: draft.pesoLiquido,
      dimensaoAltura: draft.dimensaoAltura,
      dimensaoLargura: draft.dimensaoLargura,
      dimensaoProfundidade: draft.dimensaoProfundidade,
    );

    await state.adicionarCommand.execute(request);
    onFinishEvent?.call();
  }

  void salvarDadosBasicos({
    required String nomeProduto,
    String? descricaoProduto,
    int? unidadeMedidaId,
    int? grupoId,
    int? subgrupoId,
    String? marca,
    String? fornecedor,
  }) {
    final currentDraft = state.produtoDraft;
    final updatedDraft = (currentDraft ?? ProdutoResponse()).copyWith(
      nomeProduto: nomeProduto,
      descricaoProduto: descricaoProduto,
      marca: marca,
      fornecedor: fornecedor,
      unidadeMedidaId: unidadeMedidaId,
      grupoId: grupoId,
      subgrupoId: subgrupoId,
    );
    state = state.copyWith(produtoDraft: updatedDraft);
  }

  void salvarDadosPrecosMargens({
    required double precoCusto,
    required double precoSugerido,
    required double margemMinima,
    required double aliquotaIcms,
    required double aliquotaIpi,
    required double quantidadeDisponivel,
    required double quantidadeReservada,
    required double pesoLiquido,
    required double dimensaoAltura,
    required double dimensaoLargura,
    required double dimensaoProfundidade,
  }) {
    final currentDraft = state.produtoDraft;
    final updatedDraft = (currentDraft ?? ProdutoResponse()).copyWith(
      precoCusto: precoCusto,
      precoSugerido: precoSugerido,
      margemMinima: margemMinima,
      aliquotaIcms: aliquotaIcms,
      aliquotaIpi: aliquotaIpi,
      quantidadeDisponivel: quantidadeDisponivel,
      quantidadeReservada: quantidadeReservada,
      pesoLiquido: pesoLiquido,
      dimensaoAltura: dimensaoAltura,
      dimensaoLargura: dimensaoLargura,
      dimensaoProfundidade: dimensaoProfundidade,
    );
    state = state.copyWith(produtoDraft: updatedDraft);
  }

  Future<Result<ProdutoResponse>> _adicionarProduto(
    AdicionarProdutoRequest request,
  ) async {
    onStartEvent?.call();
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .adicionarProduto(request);

    if (result is Success<ProdutoResponse>) {
      onAdicionarSucesso?.call();
    } else if (result is Failure<ProdutoResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }

  Future<Result<List<ProdutoUnidadeMedidaResponse>>>
  _listarProdutoUnidadeMedida() async {
    onStartEvent?.call();
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .listarUnidadesMedida();

    if (result is Success<List<ProdutoUnidadeMedidaResponse>>) {
      state = state.copyWith(unidadesMedida: result.value);
    } else if (result is Failure<List<ProdutoUnidadeMedidaResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<List<ProdutoGrupoResponse>>> _listarProdutoGrupo() async {
    onStartEvent?.call();
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .listarGrupos();

    if (result is Success<List<ProdutoGrupoResponse>>) {
      state = state.copyWith(grupos: result.value);
    } else if (result is Failure<List<ProdutoGrupoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<List<ProdutoSubgrupoResponse>>> _listarProdutoSubgrupo() async {
    onStartEvent?.call();
    final result = await ref
        .read(produtoRepositoryHybridProvider)
        .listarSubgrupos();

    if (result is Success<List<ProdutoSubgrupoResponse>>) {
      state = state.copyWith(subgrupos: result.value);
    } else if (result is Failure<List<ProdutoSubgrupoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  void selectUnidadeMedida(ProdutoUnidadeMedidaResponse? unidadeMedida) {
    state = state.copyWith(selectedUnidadeMedida: unidadeMedida);
  }

  void selectGrupo(ProdutoGrupoResponse? grupo) {
    state = state.copyWith(selectedGrupo: grupo);
  }

  void selectSubgrupo(ProdutoSubgrupoResponse? subgrupo) {
    state = state.copyWith(selectedSubgrupo: subgrupo);
  }

  ProdutoUnidadeMedidaResponse? get computedSelectedUnidadeMedida {
    final unidadeMedidaId = (state.produtoDraft)?.unidadeMedidaId;
    if (unidadeMedidaId == null || state.unidadesMedida == null) return null;

    final found = state.unidadesMedida!.firstWhere(
      (u) => u.id == unidadeMedidaId,
      orElse: () =>
          ProdutoUnidadeMedidaResponse(id: -1, descricaoUnidadeMedida: ''),
    );
    return found.id == -1 ? null : found;
  }

  ProdutoGrupoResponse? get computedSelectedGrupo {
    final grupoId = (state.produtoDraft)?.grupoId;
    if (grupoId == null || state.grupos == null) return null;

    final found = state.grupos!.firstWhere(
      (g) => g.id == grupoId,
      orElse: () => ProdutoGrupoResponse(id: -1, descricaoGrupo: ''),
    );
    return found.id == -1 ? null : found;
  }

  ProdutoSubgrupoResponse? get computedSelectedSubgrupo {
    final subgrupoId = (state.produtoDraft)?.subgrupoId;
    if (subgrupoId == null || state.subgrupos == null) return null;

    final found = state.subgrupos!.firstWhere(
      (s) => s.id == subgrupoId,
      orElse: () => ProdutoSubgrupoResponse(id: -1, descricaoSubgrupo: ''),
    );
    return found.id == -1 ? null : found;
  }

  DropdownLoadingState get grupoDropdownState {
    if (state.listarGrupoCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarGrupoCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  DropdownLoadingState get subgrupoDropdownState {
    if (state.listarSubgrupoCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarSubgrupoCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  DropdownLoadingState get unidadeMedidaDropdownState {
    if (state.listarUnidadeMedidaCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarUnidadeMedidaCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }
}

final produtoAdicionarViewModelProvider =
    NotifierProvider.autoDispose<
      ProdutoAdicionarViewModel,
      ProdutoAdicionarUiState
    >(() => ProdutoAdicionarViewModel());
