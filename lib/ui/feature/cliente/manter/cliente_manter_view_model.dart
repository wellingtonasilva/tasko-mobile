import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteManterViewModel extends Notifier<ClienteManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onManterSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  ClienteManterUiState build() {
    return ClienteManterUiState(
      cliente: null,
      obterPorIdCommand: Command1<ClienteResponse, (int id,)>(_obterPorId),
      atualizarCommand:
          Command1<ClienteResponse, (int id, AtualizarClienteRequest request)>(
            _atualizar,
          ),
    );
  }

  Future<Result<ClienteResponse>> _obterPorId((int id,) parameters) async {
    final (id,) = parameters;
    final result = await ref
        .read(clienteRepositoryHybridProvider)
        .obterPorId(id);

    if (result is Success<ClienteResponse>) {
      state = state.copyWith(cliente: result.value);
    } else if (result is Failure<ClienteResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    return result;
  }

  Future<Result<ClienteResponse>> _atualizar(
    (int id, AtualizarClienteRequest request) parameters,
  ) async {
    final (id, request) = parameters;
    final result = await ref
        .read(clienteRepositoryHybridProvider)
        .atualizar(id, request);

    if (result is Success<ClienteResponse>) {
      state = state.copyWith(cliente: result.value);
      showSnackBar?.call('Cliente atualizado com sucesso!', result);
    } else if (result is Failure<ClienteResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }

    return result;
  }
}

final clienteManterViewModelProvider =
    NotifierProvider<ClienteManterViewModel, ClienteManterUiState>(
      ClienteManterViewModel.new,
    );
