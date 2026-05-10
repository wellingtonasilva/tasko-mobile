import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/command.dart';

class TerritorioManterUiState {
  VendedorTerritorioResponse? territorio;
  final Command1<VendedorTerritorioResponse, (int id,)> obterPorIdCommand;
  final Command1<
    VendedorTerritorioResponse,
    (int id, AtualizarVendedorTerritorioRequest request)
  >
  atualizarCommand;

  final List<VendedorSupervisorResponse> supervisores;
  final Command0 listarSupervisoresCommand;
  VendedorSupervisorResponse? selectedSupervisor;

  TerritorioManterUiState({
    this.territorio,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
    required this.supervisores,
    required this.listarSupervisoresCommand,
    this.selectedSupervisor,
  });

  TerritorioManterUiState copyWith({
    VendedorTerritorioResponse? territorio,
    Command1<VendedorTerritorioResponse, (int id,)>? obterPorIdCommand,
    Command1<
      VendedorTerritorioResponse,
      (int id, AtualizarVendedorTerritorioRequest request)
    >?
    atualizarCommand,
    List<VendedorSupervisorResponse>? supervisores,
    Command0? listarSupervisoresCommand,
    VendedorSupervisorResponse? selectedSupervisor,
  }) {
    return TerritorioManterUiState(
      territorio: territorio ?? this.territorio,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
      supervisores: supervisores ?? this.supervisores,
      listarSupervisoresCommand:
          listarSupervisoresCommand ?? this.listarSupervisoresCommand,
      selectedSupervisor: selectedSupervisor ?? this.selectedSupervisor,
    );
  }
}
