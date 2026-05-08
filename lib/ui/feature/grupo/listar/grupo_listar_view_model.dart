import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_hybrid.dart';
import 'package:tasko_mobile/domain/produto/response/produto_grupo_response.dart';
import 'package:tasko_mobile/ui/feature/grupo/listar/grupo_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class GrupoListarViewModel extends Notifier<GrupoListarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onExcluirSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  GrupoListarUiState build() {
    return GrupoListarUiState(
      grupos: [],
      listarGruposCommand: Command0(_listarSupervisores)..execute(),
      excluirGrupoCommand: Command1<void, int>(_excluirGrupo),
    );
  }

  Future<Result<List<ProdutoGrupoResponse>>> _listarSupervisores() async {
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

  Future<Result<void>> _excluirGrupo(int id) async {
    return Result.failure(['Exclusão de grupo não implementada']);
  }
}

final grupoListarViewModelProvider =
    NotifierProvider<GrupoListarViewModel, GrupoListarUiState>(
      () => GrupoListarViewModel(),
    );
