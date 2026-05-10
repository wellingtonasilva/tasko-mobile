import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/grupo/grupo_repository_remote.dart';
import 'package:tasko_mobile/domain/grupo/request/atualizar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/ui/feature/grupo/manter/grupo_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class GrupoManterViewModel extends Notifier<GrupoManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onManterSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  GrupoManterUiState build() {
    return GrupoManterUiState(
      obterPorIdCommand: Command1(_obterPorId),
      atualizarCommand: Command1(_atualizar),
    );
  }

  Future<Result<ProdutoGrupoResponse>> _obterPorId((int id,) parameters) async {
    onStartEvent?.call();
    final (id,) = parameters;
    final result = await ref.read(grupoRepositoryRemoteProvider).obterPorId(id);
    if (result is Success<ProdutoGrupoResponse>) {
      state = state.copyWith(grupo: result.value);
    } else if (result is Failure<ProdutoGrupoResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<ProdutoGrupoResponse>> _atualizar(
    (int id, AtualizarProdutoGrupoRequest request) parameters,
  ) async {
    onStartEvent?.call();
    final (id, request) = parameters;
    final result = await ref
        .read(grupoRepositoryRemoteProvider)
        .atualizar(id, request);
    if (result is Success<ProdutoGrupoResponse>) {
      state = state.copyWith(grupo: null);
      onManterSucesso?.call();
    } else if (result is Failure<ProdutoGrupoResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }
}

final grupoManterViewModelProvider =
    NotifierProvider<GrupoManterViewModel, GrupoManterUiState>(
      () => GrupoManterViewModel(),
    );
