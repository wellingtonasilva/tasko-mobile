import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/subgrupo/subgrupo_repository_remote.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/domain/subgrupo/request/atualizar_produto_subgrupo_request.dart';
import 'package:tasko_mobile/ui/feature/subgrupo/manter/subgrupo_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class SubgrupoManterViewModel extends Notifier<SubgrupoManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onManterSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  SubgrupoManterUiState build() {
    return SubgrupoManterUiState(
      obterPorIdCommand: Command1(_obterPorId),
      atualizarCommand: Command1(_atualizar),
    );
  }

  Future<Result<ProdutoSubgrupoResponse>> _obterPorId(
    (int id,) parameters,
  ) async {
    onStartEvent?.call();
    final (id,) = parameters;
    final result = await ref
        .read(subgrupoRepositoryRemoteProvider)
        .obterPorId(id);
    if (result is Success<ProdutoSubgrupoResponse>) {
      state = state.copyWith(subgrupo: result.value);
    } else if (result is Failure<ProdutoSubgrupoResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<ProdutoSubgrupoResponse>> _atualizar(
    (int id, AtualizarProdutoSubgrupoRequest request) parameters,
  ) async {
    onStartEvent?.call();
    final (id, request) = parameters;
    final result = await ref
        .read(subgrupoRepositoryRemoteProvider)
        .atualizar(id, request);
    if (result is Success<ProdutoSubgrupoResponse>) {
      state = state.copyWith(subgrupo: null);
      onManterSucesso?.call();
    } else if (result is Failure<ProdutoSubgrupoResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }
}

final subgrupoManterViewModelProvider =
    NotifierProvider.autoDispose<
      SubgrupoManterViewModel,
      SubgrupoManterUiState
    >(() => SubgrupoManterViewModel());
