import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository_remote.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/ui/feature/supervisor/manter/supervisor_manter_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class SupervisorManterViewModel extends Notifier<SupervisorManterUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onManterSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  SupervisorManterUiState build() {
    return SupervisorManterUiState(
      obterPorIdCommand: Command1<VendedorSupervisorResponse, (int id,)>(
        _obterPorId,
      ),
      atualizarCommand:
          Command1<
            VendedorSupervisorResponse,
            (int id, AtualizarVendedorSupervisorRequest request)
          >(_atualizar),
    );
  }

  Future<Result<VendedorSupervisorResponse>> _obterPorId(
    (int id,) parameters,
  ) async {
    onStartEvent?.call();
    final (id,) = parameters;
    final result = await ref
        .read(vendedorSupervisorRepositoryRemoteProvider)
        .obterPorId(id);
    if (result is Success<VendedorSupervisorResponse>) {
      state = state.copyWith(supervisor: result.value);
    } else if (result is Failure<VendedorSupervisorResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  Future<Result<VendedorSupervisorResponse>> _atualizar(
    (int id, AtualizarVendedorSupervisorRequest request) parameters,
  ) async {
    onStartEvent?.call();
    final (id, request) = parameters;
    final result = await ref
        .read(vendedorSupervisorRepositoryRemoteProvider)
        .atualizar(id, request);
    if (result is Success<VendedorSupervisorResponse>) {
      state = state.copyWith(supervisor: null);
      onManterSucesso?.call();
    } else if (result is Failure<VendedorSupervisorResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();

    return result;
  }
}

final supervisorManterViewModelProvider =
    NotifierProvider<SupervisorManterViewModel, SupervisorManterUiState>(
      () => SupervisorManterViewModel(),
    );
