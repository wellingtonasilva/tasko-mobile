import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/ui/feature/cliente/listar/cliente_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteListarViewModel extends Notifier<ClienteListarUiState> {
  void Function(String, Result result)? showSnackBar;

  @override
  ClienteListarUiState build() {
    return ClienteListarUiState(
      clientes: [],
      listarClientesCommand: Command0<void>(_listarClientes)..execute(),
      excluirClienteCommand: Command1<void, int>(_excluirCliente),
    );
  }

  int? get _vendedorSelecionadoId => ref.read(vendedorSelecionadoIdProvider);

  Future<Result<void>> _listarClientes() async {
    final repository = ref.read(clienteRepositoryHybridProvider);
    final result = await repository.listar(vendedorId: _vendedorSelecionadoId);

    if (result is Success<List<ClienteResponse>>) {
      state = state.copyWith(clientes: result.value);
      unawaited(
        _sincronizarEmBackground(
          repository,
          vendedorId: _vendedorSelecionadoId,
        ),
      );
    } else if (result is Failure) {
      state = state.copyWith(
        clientes: [],
        listarClientesCommand: state.listarClientesCommand,
      );
      showSnackBar?.call(
        (result as Failure).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    return result;
  }

  Future<void> _sincronizarEmBackground(
    ClienteRepositoryHybrid repository, {
    int? vendedorId,
  }) async {
    final syncResult = await repository.sincronizarListaComServidor(
      vendedorId: vendedorId,
    );
    if (syncResult is Success<List<ClienteResponse>>) {
      state = state.copyWith(clientes: syncResult.value);
    }
  }

  Future<Result<void>> _excluirCliente(int id) async {
    final repository = ref.read(clienteRepositoryHybridProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarClientes();
      showSnackBar?.call('Cliente excluido com sucesso!', result);
    } else if (result is Failure<void>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    return result;
  }
}

final clienteListarViewModelProvider =
    NotifierProvider.autoDispose<ClienteListarViewModel, ClienteListarUiState>(
      ClienteListarViewModel.new,
    );
