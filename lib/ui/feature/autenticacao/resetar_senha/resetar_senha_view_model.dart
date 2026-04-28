import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/login/login_repository_remote.dart';
import 'package:tasko_mobile/domain/usuario/request/resetar_senha_request.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/resetar_senha/resetar_senha_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class ResetarSenhaViewModel extends Notifier<ResetarSenhaUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onResetarSenhaSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  ResetarSenhaUiState build() {
    return ResetarSenhaUiState(
      resetarSenhaCommand: Command1<void, ResetarSenhaRequest>(_resetarSenha),
    );
  }

  Future<Result<void>> _resetarSenha(ResetarSenhaRequest request) async {
    onStartEvent?.call();
    final result = await ref
        .read(loginRepositoryRemoteProvider)
        .resetarSenha(request);

    if (result is Success<void>) {
      showSnackBar?.call('Senha resetada com sucesso!', result);
      onResetarSenhaSucesso?.call();
    } else if (result is Failure<void>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }
}

final resetarSenhaViewModelProvider =
    NotifierProvider<ResetarSenhaViewModel, ResetarSenhaUiState>(
      () => ResetarSenhaViewModel(),
    );
