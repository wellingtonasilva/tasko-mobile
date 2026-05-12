import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/command.dart';

class AgendaVisitaCriarUiState {
  final Command1<AgendaVisitaResponse, AdicionarAgendaVisitaRequest>
  adicionarCommand;
  final Command1<AgendaVisitaResponse, AdicionarAgendaVisitaRequest>
  salvarVisitaCommand;

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

  AgendaVisitaCriarUiState({
    required this.adicionarCommand,
    required this.salvarVisitaCommand,
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

  AgendaVisitaCriarUiState copyWith({
    Command1<AgendaVisitaResponse, AdicionarAgendaVisitaRequest>?
    adicionarCommand,
    Command0<void>? listarVendedorCommand,
    List<VendedorResponse>? vendedores,
    VendedorResponse? selectedVendedor,
    Command0<void>? listarClienteCommand,
    List<ClienteResponse>? clientes,
    ClienteResponse? selectedCliente,
    Command0<void>? listarStatusCommand,
    List<AgendaVisitaStatusResponse>? statusList,
    AgendaVisitaStatusResponse? selectedStatus,
    Command1<AgendaVisitaResponse, AdicionarAgendaVisitaRequest>?
    salvarVisitaCommand,
  }) {
    return AgendaVisitaCriarUiState(
      listarClienteCommand: listarClienteCommand ?? this.listarClienteCommand,
      clientes: clientes ?? this.clientes,
      selectedCliente: selectedCliente ?? this.selectedCliente,
      adicionarCommand: adicionarCommand ?? this.adicionarCommand,
      listarVendedorCommand:
          listarVendedorCommand ?? this.listarVendedorCommand,
      vendedores: vendedores ?? this.vendedores,
      selectedVendedor: selectedVendedor ?? this.selectedVendedor,
      listarStatusCommand: listarStatusCommand ?? this.listarStatusCommand,
      statusList: statusList ?? this.statusList,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      salvarVisitaCommand: salvarVisitaCommand ?? this.salvarVisitaCommand,
    );
  }
}

/*
class AgendaVisitaCriarUiState {
  final List<ClienteResponse> clientes;
  final ClienteResponse? clienteSelecionado;
  final List<AgendaVisitaStatusResponse> statusList;
  final AgendaVisitaStatusResponse? statusSelecionado;
  final DateTime dataAgendada;
  final int? duracaoPrevista;
  final String? objetivo;
  final String? observacao;
  final List<VendedorResponse> vendedores;
  final VendedorResponse? vendedorSelecionado;
  final Command0<void> carregarDadosCommand;
  final Command1<AgendaVisitaResponse, void> salvarVisitaCommand;

  AgendaVisitaCriarUiState({
    required this.clientes,
    this.clienteSelecionado,
    required this.statusList,
    this.statusSelecionado,
    required this.dataAgendada,
    this.duracaoPrevista,
    this.objetivo,
    this.observacao,
    required this.vendedores,
    this.vendedorSelecionado,
    required this.carregarDadosCommand,
    required this.salvarVisitaCommand,
  });

  AgendaVisitaCriarUiState copyWith({
    List<ClienteResponse>? clientes,
    ClienteResponse? clienteSelecionado,
    bool clearCliente = false,
    List<AgendaVisitaStatusResponse>? statusList,
    AgendaVisitaStatusResponse? statusSelecionado,
    bool clearStatus = false,
    DateTime? dataAgendada,
    int? duracaoPrevista,
    bool clearDuracaoPrevista = false,
    String? objetivo,
    bool clearObjetivo = false,
    String? observacao,
    bool clearObservacao = false,
    Command0<void>? carregarDadosCommand,
    Command1<AgendaVisitaResponse, void>? salvarVisitaCommand,
    List<VendedorResponse>? vendedores,
    VendedorResponse? vendedorSelecionado,
    bool clearVendedor = false,
  }) {
    return AgendaVisitaCriarUiState(
      clientes: clientes ?? this.clientes,
      clienteSelecionado: clearCliente
          ? null
          : (clienteSelecionado ?? this.clienteSelecionado),
      statusList: statusList ?? this.statusList,
      statusSelecionado: clearStatus
          ? null
          : (statusSelecionado ?? this.statusSelecionado),
      dataAgendada: dataAgendada ?? this.dataAgendada,
      duracaoPrevista: clearDuracaoPrevista
          ? null
          : (duracaoPrevista ?? this.duracaoPrevista),
      objetivo: clearObjetivo ? null : (objetivo ?? this.objetivo),
      observacao: clearObservacao ? null : (observacao ?? this.observacao),
      carregarDadosCommand: carregarDadosCommand ?? this.carregarDadosCommand,
      salvarVisitaCommand: salvarVisitaCommand ?? this.salvarVisitaCommand,
      vendedores: vendedores ?? this.vendedores,
      vendedorSelecionado: clearVendedor
          ? null
          : (vendedorSelecionado ?? this.vendedorSelecionado),
    );
  }
}

*/
