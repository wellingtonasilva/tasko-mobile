import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita/agenda_visita_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/agenda_visita_status/agenda_visita_status_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_remote.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/atualizar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/manter/agenda_visita_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaManterViewModel extends Notifier<AgendaVisitaManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onManterSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  AgendaVisitaManterUiState build() {
    return AgendaVisitaManterUiState(
      obterPorIdCommand: Command1<AgendaVisitaResponse, int>(_obterPorId),
      atualizarCommand:
          Command1<AgendaVisitaResponse, AtualizarAgendaVisitaRequest>(
            _atualizar,
          ),
      listarVendedorCommand: Command0<void>(_listarVendedor)..execute(),
      listarClienteCommand: Command0<void>(_listarCliente)..execute(),
      listarStatusCommand: Command0<void>(_listarStatus)..execute(),
    );
  }

  Future<Result<AgendaVisitaResponse>> _obterPorId(int id) async {
    onStartEvent?.call();
    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final result = await repository.obterPorId(id);
    if (result is Success<AgendaVisitaResponse>) {
      state = state.copyWith(
        visita: result.value,
        selectedVendedor: computedSelectedVendedor,
        selectedCliente: computedSelectedCliente,
        selectedStatus: computedSelectedStatus,
      );
    } else if (result is Failure<AgendaVisitaResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<AgendaVisitaResponse>> _atualizar(
    AtualizarAgendaVisitaRequest request,
  ) async {
    onStartEvent?.call();
    final repository = ref.read(agendaVisitaRepositoryHybridProvider);
    final result = await repository.atualizar(state.visita!.id, request);
    if (result is Success<AgendaVisitaResponse>) {
      state = state.copyWith(visita: result.value);
      onManterSucesso?.call();
    } else if (result is Failure<AgendaVisitaResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
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
    final vendedorId = state.selectedVendedor?.id ?? state.visita?.vendedorId;
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
    final clienteId = state.selectedCliente?.id ?? state.visita?.clienteId;
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
    final statusId =
        state.selectedStatus?.id ?? state.visita?.agendaVisitaStatusId;
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

final agendaVisitaManterViewModelProvider =
    NotifierProvider<AgendaVisitaManterViewModel, AgendaVisitaManterUiState>(
      () => AgendaVisitaManterViewModel(),
    );
