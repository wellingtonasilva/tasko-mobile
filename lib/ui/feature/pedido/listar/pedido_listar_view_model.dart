import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository_hybrid.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/pedido_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoListarViewModel extends Notifier<PedidoListarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  PedidoListarUiState build() {
    return PedidoListarUiState(
      pedidos: [],
      listarPedidosCommand: Command0<void>(_listarPedidos)..execute(),
      excluirPedidoCommand: Command1<void, int>(_excluirPedido),
    );
  }

  int? get _vendedorSelecionadoId => ref.read(vendedorSelecionadoIdProvider);

  Future<Result<void>> _listarPedidos() async {
    onStartEvent?.call();
    final repository = ref.read(pedidoRepositoryHybridProvider);
    final result = await repository.listar(vendedorId: _vendedorSelecionadoId);

    if (result is Success<List<PedidoResponse>>) {
      state = state.copyWith(pedidos: result.value);
      unawaited(
        _sincronizarEmBackground(
          repository,
          vendedorId: _vendedorSelecionadoId,
        ),
      );
    } else if (result is Failure) {
      state = state.copyWith(
        pedidos: [],
        listarPedidosCommand: state.listarPedidosCommand,
      );
      showSnackBar?.call(
        (result as Failure).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<void> _sincronizarEmBackground(
    PedidoRepositoryHybrid repository, {
    int? vendedorId,
  }) async {
    onStartEvent?.call();
    final syncResult = await repository.sincronizarListaComServidor(
      vendedorId: vendedorId,
    );
    if (syncResult is Success<List<PedidoResponse>>) {
      state = state.copyWith(pedidos: syncResult.value);
    }
    onFinishEvent?.call();
  }

  Future<Result<void>> _excluirPedido(int id) async {
    onStartEvent?.call();
    final repository = ref.read(pedidoRepositoryHybridProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarPedidos();
      showSnackBar?.call('Pedido excluido com sucesso!', result);
    } else if (result is Failure<void>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }
}

final pedidoListarViewModelProvider =
    NotifierProvider<PedidoListarViewModel, PedidoListarUiState>(
      PedidoListarViewModel.new,
    );
