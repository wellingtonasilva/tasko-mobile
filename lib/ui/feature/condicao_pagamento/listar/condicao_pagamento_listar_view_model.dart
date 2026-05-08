import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/condicao_pagamento/condicao_pagamento_repository_remote.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/listar/condicao_pagamento_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class CondicaoPagamentoListarViewModel
    extends Notifier<CondicaoPagamentoListarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onExcluirSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  CondicaoPagamentoListarUiState build() {
    return CondicaoPagamentoListarUiState(
      condicoesPagamento: [],
      listarCondicoesPagamentoCommand: Command0(_listarCondicoesPagamento)
        ..execute(),
      excluirCondicaoPagamentoCommand: Command1<void, int>(
        _excluirCondicaoPagamento,
      ),
    );
  }

  Future<Result<List<CondicaoPagamentoResponse>>>
  _listarCondicoesPagamento() async {
    onStartEvent?.call();
    final result = await ref
        .read(condicaoPagamentoRepositoryRemoteProvider)
        .listar();

    if (result is Success<List<CondicaoPagamentoResponse>>) {
      state = state.copyWith(condicoesPagamento: result.value);
    } else if (result is Failure<List<CondicaoPagamentoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    onFinishEvent?.call();

    return result;
  }

  Future<Result<void>> _excluirCondicaoPagamento(int id) async {
    onStartEvent?.call();
    final repository = ref.read(condicaoPagamentoRepositoryRemoteProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarCondicoesPagamento();
      showSnackBar?.call(
        ('Condição de pagamento excluída com sucesso!'),
        result,
      );
      onExcluirSucesso?.call();
    } else if (result is Failure) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }
}

final condicaoPagamentoListarViewModelProvider =
    NotifierProvider<
      CondicaoPagamentoListarViewModel,
      CondicaoPagamentoListarUiState
    >(() => CondicaoPagamentoListarViewModel());
