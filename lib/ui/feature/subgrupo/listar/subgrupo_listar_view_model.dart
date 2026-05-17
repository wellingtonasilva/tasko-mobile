import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/subgrupo/subgrupo_repository_remote.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/ui/feature/subgrupo/listar/subgrupo_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class SubgrupoListarViewModel extends Notifier<SubgrupoListarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onExcluirSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  SubgrupoListarUiState build() {
    return SubgrupoListarUiState(
      subgrupos: [],
      listarSubgruposCommand: Command0(_listarSubgrupos)..execute(),
      excluirSubgrupoCommand: Command1<void, int>(_excluirSubgrupo),
    );
  }

  Future<Result<List<ProdutoSubgrupoResponse>>> _listarSubgrupos() async {
    onStartEvent?.call();
    final result = await ref.read(subgrupoRepositoryRemoteProvider).listar();

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

  Future<Result<void>> _excluirSubgrupo(int id) async {
    return Result.failure(['Exclusão de subgrupo não implementada']);
  }
}

final subgrupoListarViewModelProvider =
    NotifierProvider.autoDispose<
      SubgrupoListarViewModel,
      SubgrupoListarUiState
    >(() => SubgrupoListarViewModel());
