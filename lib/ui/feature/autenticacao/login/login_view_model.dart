import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/login/login_repository_remote.dart';
import 'package:tasko_mobile/domain/usuario/request/login_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/login/login_ui_state.dart';
import 'package:tasko_mobile/common/core/auth_persistence.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class LoginViewModel extends Notifier<LoginUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onLoginSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  LoginUiState build() {
    return LoginUiState(
      loginCommand: Command1<UsuarioLoginResponse, LoginRequest>(_login),
    );
  }

  Future<Result<UsuarioLoginResponse>> _login(LoginRequest request) async {
    onStartEvent?.call();
    final result = await ref.read(loginRepositoryRemoteProvider).login(request);
    if (result is Success<UsuarioLoginResponse>) {
      // Persistir token e empresaId
      final storage = ref.read(authLocalStorageProvider);
      await persistLoginData(result.value, storage);
      showSnackBar?.call('Login realizado com sucesso!', result);
      onLoginSucesso?.call();
    } else if (result is Failure<UsuarioLoginResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }
}

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginUiState>(
  () => LoginViewModel(),
);
