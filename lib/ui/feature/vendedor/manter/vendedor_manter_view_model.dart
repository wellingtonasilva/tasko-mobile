import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/territorio/vendedor_territorio_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_remote.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorManterViewModel extends Notifier<VendedorManterUiState> {
  void Function(String, Result result)? showSnackBar;

  @override
  VendedorManterUiState build() {
    return VendedorManterUiState(
      obterPorIdCommand: Command1<VendedorResponse, (int id,)>(_obterPorId),
      atualizarCommand:
          Command1<
            VendedorResponse,
            (int id, AtualizarVendedorRequest request)
          >(_atualizar),
      listarSupervisorCommand: Command0<void>(_listarSupervisor)..execute(),
      listarTerritorioCommand: Command0<void>(_listarTerritorio)..execute(),
    );
  }

  void selectSupervisor(VendedorSupervisorResponse? supervisor) {
    state = state.copyWith(selectedSupervisor: supervisor);
  }

  VendedorSupervisorResponse? get computedSelectedSupervisor {
    if (state.vendedor?.supervisor == null || state.supervisores == null) {
      return null;
    }

    return state.supervisores!.firstWhere(
      (s) => s.id == state.vendedor?.supervisor!.id,
      orElse: () => VendedorSupervisorResponse(id: -1),
    );
  }

  DropdownLoadingState get supervisorDropdownState {
    if (state.listarSupervisorCommand.running ||
        state.obterPorIdCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarSupervisorCommand.completed &&
        state.obterPorIdCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  Future<Result<VendedorResponse>> _obterPorId((int id,) parameters) async {
    final (id,) = parameters;
    final result = await ref
        .read(vendedorRepositoryRemoteProvider)
        .obterPorId(id);
    if (result is Success<VendedorResponse>) {
      state = state.copyWith(vendedor: result.value);
    } else if (result is Failure<VendedorResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  Future<Result<VendedorResponse>> _atualizar(
    (int id, AtualizarVendedorRequest request) parameters,
  ) async {
    final (id, request) = parameters;
    final result = await ref
        .read(vendedorRepositoryRemoteProvider)
        .atualizar(id, request);
    if (result is Success<VendedorResponse>) {
      state = state.copyWith(vendedor: null);
    } else if (result is Failure<VendedorResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }

  Future<Result<List<VendedorSupervisorResponse>>> _listarSupervisor() async {
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
    return result;
  }

  Future<Result<List<VendedorTerritorioResponse>>> _listarTerritorio() async {
    final result = await ref
        .read(vendedorTerritorioRepositoryRemoteProvider)
        .listar();
    if (result is Success<List<VendedorTerritorioResponse>>) {
      state = state.copyWith(territorios: result.value);
    } else if (result is Failure<List<VendedorTerritorioResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }
}

final vendedorManterViewModelProvider =
    NotifierProvider<VendedorManterViewModel, VendedorManterUiState>(
      () => VendedorManterViewModel(),
    );
