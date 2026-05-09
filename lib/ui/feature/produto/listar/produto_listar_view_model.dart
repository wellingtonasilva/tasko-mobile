import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_hybrid.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/ui/feature/produto/listar/produto_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoListarViewModel extends Notifier<ProdutoListarUiState> {
  void Function(String, Result result)? showSnackBar;

  @override
  ProdutoListarUiState build() {
    return ProdutoListarUiState(
      produtos: [],
      grupos: [],
      grupoSelecionadoId: null,
      termoBusca: '',
      listarProdutosCommand: Command0<void>(_listarProdutos),
      carregarGruposCommand: Command0<void>(_carregarGrupos),
    );
  }

  void atualizarBusca(String value) {
    state = state.copyWith(termoBusca: value);
    unawaited(_listarProdutos());
  }

  void selecionarGrupo(int? grupoId) {
    state = state.copyWith(
      grupoSelecionadoId: grupoId,
      limparGrupoSelecionado: grupoId == null,
    );
    unawaited(_listarProdutos());
  }

  Future<Result<void>> _carregarGrupos() async {
    final repository = ref.read(produtoRepositoryHybridProvider);
    final result = await repository.listarGrupos();

    if (result is Success<List<ProdutoGrupoResponse>>) {
      state = state.copyWith(grupos: result.value);
      return Result.success(null);
    }

    final failure = result as Failure<List<ProdutoGrupoResponse>>;
    showSnackBar?.call(
      failure.errors?.first ?? 'Falha ao carregar grupos',
      failure,
    );
    return Result.failure(failure.errors);
  }

  Future<Result<void>> _listarProdutos() async {
    final repository = ref.read(produtoRepositoryHybridProvider);
    final result = await repository.listar(
      termoBusca: state.termoBusca,
      grupoId: state.grupoSelecionadoId,
    );

    if (result is Success<List<ProdutoResponse>>) {
      state = state.copyWith(produtos: result.value);
      unawaited(_sincronizarEmBackground(repository));
    } else if (result is Failure<List<ProdutoResponse>>) {
      state = state.copyWith(produtos: []);
      showSnackBar?.call(
        result.errors?.first ?? 'Falha ao listar produtos',
        result,
      );
    }

    return Result.success(null);
  }

  Future<void> _sincronizarEmBackground(
    ProdutoRepositoryHybrid repository,
  ) async {
    final syncResult = await repository.sincronizarListaComServidor(
      termoBusca: state.termoBusca,
      grupoId: state.grupoSelecionadoId,
    );

    if (syncResult is Success<List<ProdutoResponse>>) {
      state = state.copyWith(produtos: syncResult.value);
    }
  }
}

final produtoListarViewModelProvider =
    NotifierProvider<ProdutoListarViewModel, ProdutoListarUiState>(
      ProdutoListarViewModel.new,
    );
