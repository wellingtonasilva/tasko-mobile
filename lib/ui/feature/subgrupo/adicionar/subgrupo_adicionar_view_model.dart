import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/subgrupo/subgrupo_repository_remote.dart';
import 'package:tasko_mobile/domain/subgrupo/request/adicionar_produto_subgrupo2_request.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/ui/feature/subgrupo/adicionar/subgrupo_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class SubgrupoAdicionarViewModel extends Notifier<SubgrupoAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  SubgrupoAdicionarUiState build() {
    return SubgrupoAdicionarUiState(
      adicionarProdutoSubgrupoCommand: Command1(_adicionar),
    );
  }

  Future<Result<ProdutoSubgrupoResponse>> _adicionar(
    AdicionarProdutoSubgrupoRequest request,
  ) async {
    onStartEvent?.call();
    final result = await ref
        .read(subgrupoRepositoryRemoteProvider)
        .adicionar(request);

    if (result is Success<ProdutoSubgrupoResponse>) {
      onAdicionarSucesso?.call();
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

final subgrupoAdicionarViewModelProvider =
    NotifierProvider.autoDispose<
      SubgrupoAdicionarViewModel,
      SubgrupoAdicionarUiState
    >(() => SubgrupoAdicionarViewModel());
