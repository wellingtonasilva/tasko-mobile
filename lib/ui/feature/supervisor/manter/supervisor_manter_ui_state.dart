import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class SupervisorManterUiState {
  VendedorSupervisorResponse? supervisor;
  final Command1<VendedorSupervisorResponse, (int id,)> obterPorIdCommand;
  final Command1<
    VendedorSupervisorResponse,
    (int id, AtualizarVendedorSupervisorRequest request)
  >
  atualizarCommand;

  SupervisorManterUiState({
    this.supervisor,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
  });

  SupervisorManterUiState copyWith({
    VendedorSupervisorResponse? supervisor,
    Command1<VendedorSupervisorResponse, (int id,)>? obterPorIdCommand,
    Command1<
      VendedorSupervisorResponse,
      (int id, AtualizarVendedorSupervisorRequest request)
    >?
    atualizarCommand,
  }) {
    return SupervisorManterUiState(
      supervisor: supervisor ?? this.supervisor,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
    );
  }
}
