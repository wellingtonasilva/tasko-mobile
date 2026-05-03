import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';
import 'pedido_criar_cliente_ui_state.dart';

class PedidoCriarClienteViewModel extends Notifier<PedidoCriarClienteUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  PedidoCriarClienteUiState build() {
    return PedidoCriarClienteUiState(
      listarClienteCommand: Command0<void>(_listarClientes),
    );
  }

  Future<Result<List<ClienteResponse>>> _listarClientes() async {
    onStartEvent?.call();
    final result = await ref.read(clienteRepositoryHybridProvider).listar();
    if (result is Success<List<ClienteResponse>>) {
      state = state.copyWith(clientes: result.value);
    } else if (result is Failure<List<ClienteResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  void selectCliente(ClienteResponse? cliente) {
    state = state.copyWith(selectedCliente: cliente);
  }

  void preencherCliente(ClienteResponse cliente) {
    state = state.copyWith(selectedCliente: cliente);
  }
}

final pedidoCriarClienteViewModelProvider =
    NotifierProvider<PedidoCriarClienteViewModel, PedidoCriarClienteUiState>(
      () => PedidoCriarClienteViewModel(),
    );
