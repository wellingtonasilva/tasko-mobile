import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/condicao_pagamento/condicao_pagamento_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/forma_pagamento/forma_pagamento_repository_remote.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/request/atualizar_condicao_pagamento_request.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/domain/forma_pagamento/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/manter/condicao_pagamento_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class CondicaoPagamentoManterViewModel
    extends Notifier<CondicaoPagamentoManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onManterSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  CondicaoPagamentoManterUiState build() {
    return CondicaoPagamentoManterUiState(
      obterPorIdCommand: Command1<CondicaoPagamentoResponse, (int id,)>(
        _obterPorId,
      ),
      atualizarCommand:
          Command1<
            CondicaoPagamentoResponse,
            (int id, AtualizarCondicaoPagamentoRequest request)
          >(_atualizar),
      formasPagamento: [],
      listarFormasPagamentoCommand: Command0<void>(_listarFormasPagamento)
        ..execute(),
    );
  }

  Future<Result<CondicaoPagamentoResponse>> _obterPorId(
    (int id,) parameters,
  ) async {
    onStartEvent?.call();
    final (id,) = parameters;
    final result = await ref
        .read(condicaoPagamentoRepositoryRemoteProvider)
        .obterPorId(id);
    if (result is Success<CondicaoPagamentoResponse>) {
      state = state.copyWith(condicaoPagamento: result.value);
    } else if (result is Failure<CondicaoPagamentoResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<CondicaoPagamentoResponse>> _atualizar(
    (int id, AtualizarCondicaoPagamentoRequest request) parameters,
  ) async {
    onStartEvent?.call();
    final (id, request) = parameters;
    final result = await ref
        .read(condicaoPagamentoRepositoryRemoteProvider)
        .atualizar(id, request);
    if (result is Success<CondicaoPagamentoResponse>) {
      state = state.copyWith(
        condicaoPagamento: null,
        selectedFormaPagamento: null,
      );
      onManterSucesso?.call();
    } else if (result is Failure<CondicaoPagamentoResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
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

  void selecionarFormaPagamento(FormaPagamentoResponse? formaPagamento) {
    state = state.copyWith(selectedFormaPagamento: formaPagamento);
  }

  FormaPagamentoResponse? get computedSelectedFormaPagamento {
    final formaPagamentoId = state.condicaoPagamento?.formaPagamentoId;
    if (formaPagamentoId == null || state.formasPagamento == null) return null;

    final found = state.formasPagamento!.firstWhere(
      (s) => s.id == formaPagamentoId,
      orElse: () => FormaPagamentoResponse(id: -1),
    );
    return found.id == -1 ? null : found;
  }

  DropdownLoadingState get formaPagamentoDropdownState {
    if (state.listarFormasPagamentoCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarFormasPagamentoCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }
}

final condicaoPagamentoManterViewModelProvider =
    NotifierProvider.autoDispose<
      CondicaoPagamentoManterViewModel,
      CondicaoPagamentoManterUiState
    >(() => CondicaoPagamentoManterViewModel());
