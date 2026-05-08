import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository_remote.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/ui/feature/supervisor/listar/supervisor_listar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class SupervisorListarViewModel extends Notifier<SupervisorListarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onExcluirSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  SupervisorListarUiState build() {
    return SupervisorListarUiState(
      supervisores: [],
      listarSupervisoresCommand: Command0(_listarSupervisores)..execute(),
      excluirSupervisorCommand: Command1<void, int>(_excluirSupervisor),
    );
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

  Future<Result<void>> _excluirSupervisor(int id) async {
    onStartEvent?.call();
    final repository = ref.read(vendedorSupervisorRepositoryRemoteProvider);
    final result = await repository.excluir(id);
    if (result is Success<void>) {
      await _listarSupervisores();
      showSnackBar?.call(('Supervisor excluído com sucesso!'), result);
      onExcluirSucesso?.call();
    } else if (result is Failure) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }
}

final supervisorListarViewModelProvider =
    NotifierProvider<SupervisorListarViewModel, SupervisorListarUiState>(
      () => SupervisorListarViewModel(),
    );
