import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class SupervisorListarUiState {
  final List<VendedorSupervisorResponse> supervisores;
  final Command0 listarSupervisoresCommand;
  final Command1 excluirSupervisorCommand;

  SupervisorListarUiState({
    required this.supervisores,
    required this.listarSupervisoresCommand,
    required this.excluirSupervisorCommand,
  });

  SupervisorListarUiState copyWith({
    List<VendedorSupervisorResponse>? supervisores,
    Command0? listarSupervisoresCommand,
    Command1? excluirSupervisorCommand,
  }) {
    return SupervisorListarUiState(
      supervisores: supervisores ?? this.supervisores,
      listarSupervisoresCommand:
          listarSupervisoresCommand ?? this.listarSupervisoresCommand,
      excluirSupervisorCommand:
          excluirSupervisorCommand ?? this.excluirSupervisorCommand,
    );
  }
}
