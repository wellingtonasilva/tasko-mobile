import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/command.dart';

class VendedorManterUiState {
  VendedorResponse? vendedor;
  final Command1<VendedorResponse, (int id,)> obterPorIdCommand;
  final Command1<VendedorResponse, (int id, AtualizarVendedorRequest request)>
  atualizarCommand;
  // Supervisor
  final Command0<void> listarSupervisorCommand;
  List<VendedorSupervisorResponse>? supervisores;
  VendedorSupervisorResponse? selectedSupervisor;
  // Territorio
  final Command0<void> listarTerritorioCommand;
  List<VendedorTerritorioResponse>? territorios;
  VendedorTerritorioResponse? selectedTerritorio;

  VendedorManterUiState({
    this.vendedor,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
    required this.listarSupervisorCommand,
    this.supervisores,
    this.selectedSupervisor,
    required this.listarTerritorioCommand,
    this.territorios,
    this.selectedTerritorio,
  });

  VendedorManterUiState copyWith({
    VendedorResponse? vendedor,
    Command1<VendedorResponse, (int id,)>? obterPorIdCommand,
    Command1<VendedorResponse, (int id, AtualizarVendedorRequest request)>?
    atualizarCommand,
    Command0<void>? listarSupervisorCommand,
    List<VendedorSupervisorResponse>? supervisores,
    VendedorSupervisorResponse? selectedSupervisor,
    Command0<void>? listarTerritorioCommand,
    List<VendedorTerritorioResponse>? territorios,
    VendedorTerritorioResponse? selectedTerritorio,
  }) {
    return VendedorManterUiState(
      vendedor: vendedor ?? this.vendedor,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
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
