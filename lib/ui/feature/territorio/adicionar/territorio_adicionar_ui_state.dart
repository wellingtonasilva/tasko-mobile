import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/command.dart';

class TerritorioAdicionarUiState {
  final Command1<VendedorTerritorioResponse, AdicionarVendedorTerritorioRequest>
  adicionarCondicaoPagamentoCommand;

  final List<VendedorSupervisorResponse> supervisores;
  final Command0 listarSupervisoresCommand;
  VendedorSupervisorResponse? selectedSupervisor;

  TerritorioAdicionarUiState({
    required this.adicionarCondicaoPagamentoCommand,
    required this.supervisores,
    required this.listarSupervisoresCommand,
    this.selectedSupervisor,
  });

  TerritorioAdicionarUiState copyWith({
    Command1<VendedorTerritorioResponse, AdicionarVendedorTerritorioRequest>?
    adicionarCondicaoPagamentoCommand,
    List<VendedorSupervisorResponse>? supervisores,
    Command0? listarSupervisoresCommand,
    VendedorSupervisorResponse? selectedSupervisor,
  }) {
    return TerritorioAdicionarUiState(
      adicionarCondicaoPagamentoCommand:
          adicionarCondicaoPagamentoCommand ??
          this.adicionarCondicaoPagamentoCommand,
      supervisores: supervisores ?? this.supervisores,
      listarSupervisoresCommand:
          listarSupervisoresCommand ?? this.listarSupervisoresCommand,
      selectedSupervisor: selectedSupervisor ?? this.selectedSupervisor,
    );
  }
}
