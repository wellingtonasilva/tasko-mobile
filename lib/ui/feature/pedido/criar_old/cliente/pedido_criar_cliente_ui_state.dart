import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoCriarClienteUiState {
  // Clientes
  final Command0<void> listarClienteCommand;
  List<ClienteResponse>? clientes;
  ClienteResponse? selectedCliente;

  PedidoCriarClienteUiState({
    required this.listarClienteCommand,
    this.clientes,
    this.selectedCliente,
  });

  PedidoCriarClienteUiState copyWith({
    Command0<void>? listarClienteCommand,
    List<ClienteResponse>? clientes,
    ClienteResponse? selectedCliente,
    bool clearSelectedCliente = false,
  }) {
    return PedidoCriarClienteUiState(
      listarClienteCommand: listarClienteCommand ?? this.listarClienteCommand,
      clientes: clientes ?? this.clientes,
      selectedCliente: clearSelectedCliente
          ? null
          : selectedCliente ?? this.selectedCliente,
    );
  }
}
