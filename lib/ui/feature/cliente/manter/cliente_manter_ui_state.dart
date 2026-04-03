import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ClienteManterUiState {
  final ClienteResponse? cliente;
  final Command1 obterPorIdCommand;
  final Command1 atualizarCommand;

  ClienteManterUiState({
    required this.cliente,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
  });

  ClienteManterUiState copyWith({
    ClienteResponse? cliente,
    Command1? obterPorIdCommand,
    Command1? atualizarCommand,
  }) {
    return ClienteManterUiState(
      cliente: cliente ?? this.cliente,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
    );
  }
}
