import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/vendedor/supervisor/vendedor_supervisor_repository_remote.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_supervisor_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/ui/feature/supervisor/adicionar/supervisor_adicionar_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class SupervisorAdicionarViewModel
    extends Notifier<SupervisorAdicionarUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onAdicionarSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  SupervisorAdicionarUiState build() {
    return SupervisorAdicionarUiState(
      adicionarVendedorSupervisorCommand: Command1(_adicionar),
    );
  }

  Future<Result<VendedorSupervisorResponse>> _adicionar(
    AdicionarVendedorSupervisorRequest request,
  ) async {
    onStartEvent?.call();
    final result = await ref
        .read(vendedorSupervisorRepositoryRemoteProvider)
        .adicionar(request);

    if (result is Success<VendedorSupervisorResponse>) {
      onAdicionarSucesso?.call();
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

final supervisorAdicionarViewModelProvider =
    NotifierProvider.autoDispose<
      SupervisorAdicionarViewModel,
      SupervisorAdicionarUiState
    >(() => SupervisorAdicionarViewModel());
