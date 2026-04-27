import 'package:tasko_mobile/domain/usuario/request/login_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/util/command.dart';

class LoginUiState {
  final Command1<UsuarioLoginResponse, LoginRequest> loginCommand;

  LoginUiState({required this.loginCommand});

  LoginUiState copyWith({
    Command1<UsuarioLoginResponse, LoginRequest>? loginCommand,
  }) {
    return LoginUiState(loginCommand: loginCommand ?? this.loginCommand);
  }
}
