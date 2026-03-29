import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/command.dart';

class VendedorAdicionarUiState {
  final Command1<VendedorResponse, AdicionarVendedorRequest> adicionarCommand;
  final Command0<void> listarSupervisorCommand;
  List<VendedorSupervisorResponse>? supervisores;
  VendedorSupervisorResponse? selectedSupervisor;
  final Command0<void> listarTerritorioCommand;
  List<VendedorTerritorioResponse>? territorios;
  VendedorTerritorioResponse? selectedTerritorio;

  VendedorAdicionarUiState({
    required this.adicionarCommand,
    required this.listarSupervisorCommand,
    this.supervisores,
    this.selectedSupervisor,
    required this.listarTerritorioCommand,
    this.territorios,
    this.selectedTerritorio,
  });

  VendedorAdicionarUiState copyWith({
    Command1<VendedorResponse, AdicionarVendedorRequest>? adicionarCommand,
    Command0<void>? listarSupervisorCommand,
    List<VendedorSupervisorResponse>? supervisores,
    VendedorSupervisorResponse? selectedSupervisor,
    Command0<void>? listarTerritorioCommand,
    List<VendedorTerritorioResponse>? territorios,
    VendedorTerritorioResponse? selectedTerritorio,
  }) {
    return VendedorAdicionarUiState(
      adicionarCommand: adicionarCommand ?? this.adicionarCommand,
      listarSupervisorCommand:
          listarSupervisorCommand ?? this.listarSupervisorCommand,
      supervisores: supervisores ?? this.supervisores,
      selectedSupervisor: selectedSupervisor ?? this.selectedSupervisor,
      listarTerritorioCommand:
          listarTerritorioCommand ?? this.listarTerritorioCommand,
      territorios: territorios ?? this.territorios,
      selectedTerritorio: selectedTerritorio ?? this.selectedTerritorio,
    );
  }
}
