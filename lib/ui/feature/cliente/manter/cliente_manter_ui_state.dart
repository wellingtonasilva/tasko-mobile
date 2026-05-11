import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/util/command.dart';

class ClienteManterUiState {
  ClienteResponse? cliente;
  ClienteResponse? clienteDraft;
  final Command1 obterPorIdCommand;
  final Command1 atualizarCommand;

  ClienteManterUiState({
    this.cliente,
    this.clienteDraft,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
  });

  ClienteManterUiState copyWith({
    ClienteResponse? cliente,
    ClienteResponse? clienteDraft,
    Command1? obterPorIdCommand,
    Command1? atualizarCommand,
  }) {
    return ClienteManterUiState(
      cliente: cliente ?? this.cliente,
      clienteDraft: clienteDraft ?? this.clienteDraft,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
    );
  }
}
