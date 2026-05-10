import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/territorio/vendedor_territorio_repository_remote.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/ui/feature/territorio/manter/territorio_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class TerritorioManterViewModel extends Notifier<TerritorioManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onManterSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  TerritorioManterUiState build() {
    return TerritorioManterUiState(
      obterPorIdCommand: Command1<VendedorTerritorioResponse, (int id,)>(
        _obterPorId,
      ),
      atualizarCommand:
          Command1<
            VendedorTerritorioResponse,
            (int id, AtualizarVendedorTerritorioRequest request)
          >(_atualizar),
      supervisores: [],
      listarSupervisoresCommand: Command0<void>(_listarSupervisores),
    );
  }

  Future<Result<VendedorTerritorioResponse>> _obterPorId(
    (int id,) parameters,
  ) async {
    onStartEvent?.call();
    final (id,) = parameters;
    final result = await ref
        .read(vendedorTerritorioRepositoryRemoteProvider)
        .obterPorId(id);
    if (result is Success<VendedorTerritorioResponse>) {
      state = state.copyWith(
        territorio: result.value,
        selectedSupervisor: result.value.supervisor,
      );
    } else if (result is Failure<VendedorTerritorioResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<VendedorTerritorioResponse>> _atualizar(
    (int id, AtualizarVendedorTerritorioRequest request) parameters,
  ) async {
    onStartEvent?.call();
    final (id, request) = parameters;
    final result = await ref
        .read(vendedorTerritorioRepositoryRemoteProvider)
        .atualizar(id, request);
    if (result is Success<VendedorTerritorioResponse>) {
      state = state.copyWith(territorio: null, selectedSupervisor: null);
      onManterSucesso?.call();
    } else if (result is Failure<VendedorTerritorioResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }

  Future<Result<List<VendedorSupervisorResponse>>> _listarSupervisores() async {
    onStartEvent?.call();
    final result = await ref
        .read(vendedorSupervisorRepositoryRemoteProvider)
        .listar();

    if (result is Success<List<VendedorSupervisorResponse>>) {
      state = state.copyWith(supervisores: result.value);
    } else if (result is Failure<List<VendedorSupervisorResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  void selecionarSupervisor(VendedorSupervisorResponse? supervisor) {
    state = state.copyWith(selectedSupervisor: supervisor);
  }

  VendedorSupervisorResponse? get computedSelectedSupervisor {
    final supervisorId = state.selectedSupervisor?.id;
    if (supervisorId == null || state.supervisores == null) return null;

    final found = state.supervisores!.firstWhere(
      (s) => s.id == supervisorId,
      orElse: () => VendedorSupervisorResponse(id: -1),
    );
    return found.id == -1 ? null : found;
  }

  DropdownLoadingState get supervisorDropdownState {
    if (state.listarSupervisoresCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarSupervisoresCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }
}

final territorioManterViewModelProvider =
    NotifierProvider.autoDispose<
      TerritorioManterViewModel,
      TerritorioManterUiState
    >(() => TerritorioManterViewModel());
