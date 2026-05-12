import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/auth_local_storage.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita/agenda_visita_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita_status/agenda_visita_status_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_remote.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/agenda_visita_criar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaCriarViewModel extends Notifier<AgendaVisitaCriarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  AgendaVisitaCriarUiState build() {
    return AgendaVisitaCriarUiState(
      adicionarCommand:
          Command1<AgendaVisitaResponse, AdicionarAgendaVisitaRequest>(
            _adicionar,
          ),
      salvarVisitaCommand:
          Command1<AgendaVisitaResponse, AdicionarAgendaVisitaRequest>(
            _salvarVisita,
          ),
      listarVendedorCommand: Command0<void>(_listarVendedor)..execute(),
      listarClienteCommand: Command0<void>(_listarCliente)..execute(),
      listarStatusCommand: Command0<void>(_listarStatus)..execute(),
    );
  }

  Future<Result<AgendaVisitaResponse>> _salvarVisita(
    AdicionarAgendaVisitaRequest adicionarRequest,
  ) async {
    final now = DateTime.now();
    final uuidOffline = 'av-${now.toUtc().microsecondsSinceEpoch}';

    final request = adicionarRequest.copyWith(
      empresaId: await ref
          .read(authLocalStorageProvider)
          .getUsuarioLoginResponse()
          .then((value) => value?.empresas?.first.empresaId ?? 0),
      vendedorId: state.selectedVendedor?.id,
      clienteId: state.selectedCliente?.id,
      agendaVisitaStatusId: state.selectedStatus?.id,
      criadoOffline: true,
      uuidOffline: uuidOffline,
    );
    /*
    AdicionarAgendaVisitaRequest(
      empresaId: await ref
          .read(authLocalStorageProvider)
          .getUsuarioLoginResponse()
          .then((value) => value?.empresas?.first.empresaId ?? 0),
      dataAgendada: state.dataAgendada.toUtc().toIso8601String(),
      duracaoPrevista: state.duracaoPrevista,
      objetivo: state.objetivo,
      observacao: state.observacao,
      
      criadoOffline: true,
      uuidOffline: uuidOffline,
    );
    */

    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final result = await repository.adicionar(request);

    if (result is Success<AgendaVisitaResponse>) {
      showSnackBar?.call('Visita agendada com sucesso!', result);
      onAdicionarSucesso?.call();
    } else if (result is Failure<AgendaVisitaResponse>) {
      showSnackBar?.call(result.errors?[0] ?? 'Erro ao agendar visita', result);
    }

    return result;
  }

  Future<Result<AgendaVisitaResponse>> _adicionar(
    AdicionarAgendaVisitaRequest request,
  ) async {
    final result = await ref
        .read(agendaVisitaRepositoryHybridProvider)
        .adicionar(request);

    if (result is Success<AgendaVisitaResponse>) {
      showSnackBar?.call('Visita adicionada com sucesso!', result);
      onAdicionarSucesso?.call();
    } else if (result is Failure<AgendaVisitaResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  //------------------- Vendedor ------------------
  Future<Result<List<VendedorResponse>>> _listarVendedor() async {
    onStartEvent?.call();
    final result = await ref.read(vendedorRepositoryRemoteProvider).listar();
    if (result is Success<List<VendedorResponse>>) {
      state = state.copyWith(vendedores: result.value);
    } else if (result is Failure<List<VendedorResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  VendedorResponse? get computedSelectedVendedor {
    final vendedorId = state.selectedVendedor?.id;
    if (vendedorId == null || state.vendedores == null) return null;

    final found = state.vendedores!.firstWhere(
      (v) => v.id == vendedorId,
      orElse: () => VendedorResponse(id: -1),
    );
    return found.id == -1 ? null : found;
  }

  DropdownLoadingState get vendedorDropdownState {
    if (state.listarVendedorCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarVendedorCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  void selectVendedor(VendedorResponse? vendedor) {
    state = state.copyWith(selectedVendedor: vendedor);
  }

  //------------------- Cliente ------------------
  Future<Result<List<ClienteResponse>>> _listarCliente() async {
    onStartEvent?.call();
    final result = await ref.read(clienteRepositoryRemoteProvider).listar();
    if (result is Success<List<ClienteResponse>>) {
      state = state.copyWith(clientes: result.value);
    } else if (result is Failure<List<ClienteResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  ClienteResponse? get computedSelectedCliente {
    final clienteId = state.selectedCliente?.id;
    if (clienteId == null || state.clientes == null) return null;

    final found = state.clientes!.firstWhere(
      (c) => c.id == clienteId,
      orElse: () => ClienteResponse(id: -1, razaoSocial: ''),
    );
    return found.id == -1 ? null : found;
  }

  DropdownLoadingState get clienteDropdownState {
    if (state.listarClienteCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarClienteCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  void selectCliente(ClienteResponse? cliente) {
    state = state.copyWith(selectedCliente: cliente);
  }

  //------------------- Status ------------------
  Future<Result<List<AgendaVisitaStatusResponse>>> _listarStatus() async {
    onStartEvent?.call();
    final result = await ref
        .read(agendaVisitaStatusRepositoryRemoteProvider)
        .listar();
    if (result is Success<List<AgendaVisitaStatusResponse>>) {
      state = state.copyWith(statusList: result.value);
    } else if (result is Failure<List<AgendaVisitaStatusResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  AgendaVisitaStatusResponse? get computedSelectedStatus {
    final statusId = state.selectedStatus?.id;
    if (statusId == null || state.statusList == null) return null;

    final found = state.statusList!.firstWhere(
      (s) => s.id == statusId,
      orElse: () =>
          AgendaVisitaStatusResponse(id: -1, descricaoVisitaStatus: ''),
    );
    return found.id == -1 ? null : found;
  }

  DropdownLoadingState get statusDropdownState {
    if (state.listarStatusCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarStatusCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  void selectStatus(AgendaVisitaStatusResponse? status) {
    state = state.copyWith(selectedStatus: status);
  }
}

/*
class AgendaVisitaCriarViewModel extends Notifier<AgendaVisitaCriarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onSalvarSucesso;

  @override
  AgendaVisitaCriarUiState build() {
    return AgendaVisitaCriarUiState(
      clientes: [],
      statusList: [],
      dataAgendada: DateTime.now(),
      carregarDadosCommand: Command0<void>(_carregarDados)..execute(),
      salvarVisitaCommand: Command1<AgendaVisitaResponse, void>(_salvarVisita),
      vendedores: [],
      vendedorSelecionado: null,
    );
  }

  int? get _vendedorSelecionadoId => ref.read(vendedorSelecionadoIdProvider);

  Future<Result<void>> _carregarDados() async {
    final clienteRepo = ref.read(clienteRepositoryHybridProvider);
    final statusService = ref.read(agendaVisitaStatusServiceProvider);
    final vendedorRepo = ref.read(vendedorRepositoryHybridProvider);

    final clienteResult = await clienteRepo.listar(
      vendedorId: _vendedorSelecionadoId,
    );
    final statusResult = await statusService.listar();
    final vendedorResult = await vendedorRepo.listar();

    state = state.copyWith(
      clientes: clienteResult is Success<List<ClienteResponse>>
          ? clienteResult.value
          : [],
      statusList: statusResult is Success<List<AgendaVisitaStatusResponse>>
          ? statusResult.value
          : [],
      vendedores: vendedorResult is Success<List<VendedorResponse>>
          ? vendedorResult.value
          : [],
    );

    return Result.success(null);
  }

  void selecionarCliente(ClienteResponse? cliente) {
    state = state.copyWith(
      clienteSelecionado: cliente,
      clearCliente: cliente == null,
    );
  }

  void selecionarStatus(AgendaVisitaStatusResponse? status) {
    state = state.copyWith(
      statusSelecionado: status,
      clearStatus: status == null,
    );
  }

  void selecionarData(DateTime data) {
    state = state.copyWith(dataAgendada: data);
  }

  void atualizarDuracao(int? duracao) {
    state = state.copyWith(
      duracaoPrevista: duracao,
      clearDuracaoPrevista: duracao == null,
    );
  }

  void atualizarObjetivo(String? objetivo) {
    state = state.copyWith(
      objetivo: objetivo,
      clearObjetivo: objetivo == null || objetivo.isEmpty,
    );
  }

  void atualizarObservacao(String? observacao) {
    state = state.copyWith(
      observacao: observacao,
      clearObservacao: observacao == null || observacao.isEmpty,
    );
  }

  void selecionarVendedor(VendedorResponse? vendedor) {
    state = state.copyWith(
      vendedorSelecionado: vendedor,
      clearVendedor: vendedor == null,
    );
  }

  Future<Result<AgendaVisitaResponse>> _salvarVisita(void _) async {
    final vendedorId = state.vendedorSelecionado?.id;
    if (vendedorId == null) {
      final Result<AgendaVisitaResponse> result = Result.failure([
        'Selecione um vendedor',
      ]);
      showSnackBar?.call('Selecione um vendedor', result);
      return result;
    }

    final now = DateTime.now();
    final uuidOffline = 'av-${now.toUtc().microsecondsSinceEpoch}';

    final request = AdicionarAgendaVisitaRequest(
      empresaId: await ref
          .read(authLocalStorageProvider)
          .getUsuarioLoginResponse()
          .then((value) => value?.empresas?.first.empresaId ?? 0),
      dataAgendada: state.dataAgendada.toUtc().toIso8601String(),
      duracaoPrevista: state.duracaoPrevista,
      objetivo: state.objetivo,
      observacao: state.observacao,
      vendedorId: vendedorId,
      clienteId: state.clienteSelecionado?.id,
      agendaVisitaStatusId: state.statusSelecionado?.id,
      criadoOffline: true,
      uuidOffline: uuidOffline,
    );

    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final result = await repository.adicionar(request);

    if (result is Success<AgendaVisitaResponse>) {
      showSnackBar?.call('Visita agendada com sucesso!', result);
      onSalvarSucesso?.call();
    } else if (result is Failure<AgendaVisitaResponse>) {
      showSnackBar?.call(result.errors?[0] ?? 'Erro ao agendar visita', result);
    }

    return result;
  }
}
*/

final agendaVisitaCriarViewModelProvider =
    NotifierProvider<AgendaVisitaCriarViewModel, AgendaVisitaCriarUiState>(
      AgendaVisitaCriarViewModel.new,
    );
