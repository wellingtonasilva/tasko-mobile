import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/grupo/grupo_repository_remote.dart';
import 'package:tasko_mobile/domain/grupo/request/adicionar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/ui/feature/grupo/adicionar/grupo_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class GrupoAdicionarViewModel extends Notifier<GrupoAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  GrupoAdicionarUiState build() {
    return GrupoAdicionarUiState(
      adicionarProdutoGrupoCommand: Command1(_adicionar),
    );
  }

  Future<Result<ProdutoGrupoResponse>> _adicionar(
    AdicionarProdutoGrupoRequest request,
  ) async {
    onStartEvent?.call();
    final result = await ref
        .read(grupoRepositoryRemoteProvider)
        .adicionar(request);

    if (result is Success<ProdutoGrupoResponse>) {
      onAdicionarSucesso?.call();
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

final grupoAdicionarViewModelProvider =
    NotifierProvider<GrupoAdicionarViewModel, GrupoAdicionarUiState>(
      () => GrupoAdicionarViewModel(),
    );
