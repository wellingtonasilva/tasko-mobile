import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoListarUiState {
  final List<PedidoResponse> pedidos;
  final Command0 listarPedidosCommand;
  final Command1 excluirPedidoCommand;

  PedidoListarUiState({
    required this.pedidos,
    required this.listarPedidosCommand,
    required this.excluirPedidoCommand,
  });

  PedidoListarUiState copyWith({
    List<PedidoResponse>? pedidos,
    Command0? listarPedidosCommand,
    Command1? excluirPedidoCommand,
  }) {
    return PedidoListarUiState(
      pedidos: pedidos ?? this.pedidos,
      listarPedidosCommand: listarPedidosCommand ?? this.listarPedidosCommand,
      excluirPedidoCommand: excluirPedidoCommand ?? this.excluirPedidoCommand,
    );
  }
}
