import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/forma_pagamento/forma_pagamento_repository_remote.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/ui/feature/forma_pagamento/listar/forma_pagamento_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class FormaPagamentoListarViewModel
    extends Notifier<FormaPagamentoListarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onExcluirSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  FormaPagamentoListarUiState build() {
    return FormaPagamentoListarUiState(
      formasPagamento: [],
      listarFormasPagamentoCommand: Command0(_listarFormasPagamento)..execute(),
      excluirFormaPagamentoCommand: Command1<void, int>(_excluirFormaPagamento),
    );
  }

  Future<Result<List<FormaPagamentoResponse>>> _listarFormasPagamento() async {
    onStartEvent?.call();
    final result = await ref
        .read(formaPagamentoRepositoryRemoteProvider)
        .listar();

    if (result is Success<List<FormaPagamentoResponse>>) {
      state = state.copyWith(formasPagamento: result.value);
    } else if (result is Failure<List<FormaPagamentoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    onFinishEvent?.call();

    return result;
  }

  Future<Result<void>> _excluirFormaPagamento(int id) async {
    onStartEvent?.call();
    final repository = ref.read(formaPagamentoRepositoryRemoteProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarFormasPagamento();
      showSnackBar?.call(('Forma de pagamento excluída com sucesso!'), result);
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

final formaPagamentoListarViewModelProvider =
    NotifierProvider<
      FormaPagamentoListarViewModel,
      FormaPagamentoListarUiState
    >(() => FormaPagamentoListarViewModel());
