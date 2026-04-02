import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ClienteListarUiState {
  final List<ClienteResponse> clientes;
  final Command0 listarClientesCommand;
  final Command1 excluirClienteCommand;

  ClienteListarUiState({
    required this.clientes,
    required this.listarClientesCommand,
    required this.excluirClienteCommand,
  });

  ClienteListarUiState copyWith({
    List<ClienteResponse>? clientes,
    Command0? listarClientesCommand,
    Command1? excluirClienteCommand,
  }) {
    return ClienteListarUiState(
      clientes: clientes ?? this.clientes,
      listarClientesCommand:
          listarClientesCommand ?? this.listarClientesCommand,
      excluirClienteCommand:
          excluirClienteCommand ?? this.excluirClienteCommand,
    );
  }
}
