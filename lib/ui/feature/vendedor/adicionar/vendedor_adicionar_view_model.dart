import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/territorio/vendedor_territorio_repository_remote.dart';
import 'package:tasko_mobile/data/repositories/vendedor/vendedor_repository_hybrid.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/vendedor_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorAdicionarViewModel extends Notifier<VendedorAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;

  @override
  VendedorAdicionarUiState build() {
    return VendedorAdicionarUiState(
      adicionarCommand: Command1<VendedorResponse, AdicionarVendedorRequest>(
        _adicionar,
      ),
      listarSupervisorCommand: Command0<void>(_listarSupervisor)..execute(),
      listarTerritorioCommand: Command0<void>(_listarTerritorio)..execute(),
    );
  }

  void selectSupervisor(VendedorSupervisorResponse? supervisor) {
    state = state.copyWith(selectedSupervisor: supervisor);
  }

  void selectTerritorio(VendedorTerritorioResponse? territorio) {
    state = state.copyWith(selectedTerritorio: territorio);
  }

  DropdownLoadingState get supervisorDropdownState {
    if (state.listarSupervisorCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarSupervisorCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  DropdownLoadingState get territorioDropdownState {
    if (state.listarTerritorioCommand.running) {
      return DropdownLoadingState.loading;
    }
    if (state.listarTerritorioCommand.completed) {
      return DropdownLoadingState.ready;
    }
    return DropdownLoadingState.error;
  }

  Future<Result<VendedorResponse>> _adicionar(
    AdicionarVendedorRequest request,
  ) async {
    final result = await ref
        .read(vendedorRepositoryHybridProvider)
        .adicionar(request);
    if (result is Success<VendedorResponse>) {
      showSnackBar?.call('Vendedor adicionado com sucesso!', result);
      onAdicionarSucesso?.call();
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

final vendedorAdicionarViewModelProvider =
    NotifierProvider<VendedorAdicionarViewModel, VendedorAdicionarUiState>(
      () => VendedorAdicionarViewModel(),
    );
