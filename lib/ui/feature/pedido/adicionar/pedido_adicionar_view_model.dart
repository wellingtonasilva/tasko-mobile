import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pedido_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoAdicionarViewModel extends Notifier<PedidoAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;
  void Function()? onAdicionarSucesso;

  @override
  PedidoAdicionarUiState build() {
    throw UnimplementedError();
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

final pedidoAdicionarViewModelProvider =
    NotifierProvider.autoDispose<
      PedidoAdicionarViewModel,
      PedidoAdicionarUiState
    >(() => PedidoAdicionarViewModel());
