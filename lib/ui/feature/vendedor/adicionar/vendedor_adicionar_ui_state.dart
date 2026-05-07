import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/command.dart';

class VendedorAdicionarUiState {
  static const Object _unset = Object();

  VendedorResponse? vendedorDraft;
  final Command1<VendedorResponse, AdicionarVendedorRequest> adicionarCommand;
  // Supervisor
  final Command0<void> listarSupervisorCommand;
  List<VendedorSupervisorResponse>? supervisores;
  VendedorSupervisorResponse? selectedSupervisor;
  // Territorio
  final Command0<void> listarTerritorioCommand;
  List<VendedorTerritorioResponse>? territorios;
  VendedorTerritorioResponse? selectedTerritorio;

  VendedorAdicionarUiState({
    this.vendedorDraft,
    required this.adicionarCommand,
    required this.listarSupervisorCommand,
    this.supervisores,
    this.selectedSupervisor,
    required this.listarTerritorioCommand,
    this.territorios,
    this.selectedTerritorio,
  });

  VendedorAdicionarUiState copyWith({
    Object? vendedorDraft = _unset,
    Command1<VendedorResponse, AdicionarVendedorRequest>? adicionarCommand,
    Command0<void>? listarSupervisorCommand,
    List<VendedorSupervisorResponse>? supervisores,
    Object? selectedSupervisor = _unset,
    Command0<void>? listarTerritorioCommand,
    List<VendedorTerritorioResponse>? territorios,
    Object? selectedTerritorio = _unset,
  }) {
    return VendedorAdicionarUiState(
      vendedorDraft: identical(vendedorDraft, _unset)
          ? this.vendedorDraft
          : vendedorDraft as VendedorResponse?,
      adicionarCommand: adicionarCommand ?? this.adicionarCommand,
      listarSupervisorCommand:
          listarSupervisorCommand ?? this.listarSupervisorCommand,
      supervisores: supervisores ?? this.supervisores,
      selectedSupervisor: identical(selectedSupervisor, _unset)
          ? this.selectedSupervisor
          : selectedSupervisor as VendedorSupervisorResponse?,
      listarTerritorioCommand:
          listarTerritorioCommand ?? this.listarTerritorioCommand,
      territorios: territorios ?? this.territorios,
      selectedTerritorio: identical(selectedTerritorio, _unset)
          ? this.selectedTerritorio
          : selectedTerritorio as VendedorTerritorioResponse?,
    );
  }
}
