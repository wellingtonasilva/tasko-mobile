import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class SupervisorAdicionarUiState {
  final Command1<VendedorSupervisorResponse, AdicionarVendedorSupervisorRequest>
  adicionarVendedorSupervisorCommand;

  SupervisorAdicionarUiState({
    required this.adicionarVendedorSupervisorCommand,
  });

  SupervisorAdicionarUiState copyWith({
    Command1<VendedorSupervisorResponse, AdicionarVendedorSupervisorRequest>?
    adicionarVendedorSupervisorCommand,
  }) {
    return SupervisorAdicionarUiState(
      adicionarVendedorSupervisorCommand:
          adicionarVendedorSupervisorCommand ??
          this.adicionarVendedorSupervisorCommand,
    );
  }
}
