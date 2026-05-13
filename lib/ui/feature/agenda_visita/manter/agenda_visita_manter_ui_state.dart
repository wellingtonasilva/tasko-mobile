import 'package:tasko_mobile/domain/agenda_visita/request/atualizar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class AgendaVisitaManterUiState {
  final AgendaVisitaResponse? visita;
  final Command1<AgendaVisitaResponse, int> obterPorIdCommand;
  final Command1<AgendaVisitaResponse, AtualizarAgendaVisitaRequest>
  atualizarCommand;

  // Vendedor
  final Command0<void> listarVendedorCommand;
  List<VendedorResponse>? vendedores;
  VendedorResponse? selectedVendedor;

  // Cliente
  final Command0<void> listarClienteCommand;
  List<ClienteResponse>? clientes;
  ClienteResponse? selectedCliente;

  // Status
  final Command0<void> listarStatusCommand;
  List<AgendaVisitaStatusResponse>? statusList;
  AgendaVisitaStatusResponse? selectedStatus;

  AgendaVisitaManterUiState({
    this.visita,
    required this.obterPorIdCommand,
    required this.atualizarCommand,
    required this.listarVendedorCommand,
    this.vendedores,
    this.selectedVendedor,
    required this.listarClienteCommand,
    this.clientes,
    this.selectedCliente,
    required this.listarStatusCommand,
    this.statusList,
    this.selectedStatus,
  });

  AgendaVisitaManterUiState copyWith({
    AgendaVisitaResponse? visita,
    Command1<AgendaVisitaResponse, int>? obterPorIdCommand,
    Command1<AgendaVisitaResponse, AtualizarAgendaVisitaRequest>?
    atualizarCommand,
    Command0<void>? listarVendedorCommand,
    List<VendedorResponse>? vendedores,
    VendedorResponse? selectedVendedor,
    Command0<void>? listarClienteCommand,
    List<ClienteResponse>? clientes,
    ClienteResponse? selectedCliente,
    Command0<void>? listarStatusCommand,
    List<AgendaVisitaStatusResponse>? statusList,
    AgendaVisitaStatusResponse? selectedStatus,
  }) {
    return AgendaVisitaManterUiState(
      visita: visita ?? this.visita,
      obterPorIdCommand: obterPorIdCommand ?? this.obterPorIdCommand,
      atualizarCommand: atualizarCommand ?? this.atualizarCommand,
      listarVendedorCommand:
          listarVendedorCommand ?? this.listarVendedorCommand,
      vendedores: vendedores ?? this.vendedores,
      selectedVendedor: selectedVendedor ?? this.selectedVendedor,
      listarClienteCommand: listarClienteCommand ?? this.listarClienteCommand,
      clientes: clientes ?? this.clientes,
      selectedCliente: selectedCliente ?? this.selectedCliente,
      listarStatusCommand: listarStatusCommand ?? this.listarStatusCommand,
      statusList: statusList ?? this.statusList,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}
