import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/util/command.dart';

class HomeScreenUiState {
  final Command0 lastLoginCommand;
  final UsuarioLoginResponse? usuarioLoginResponse;

  HomeScreenUiState({
    this.usuarioLoginResponse,
    required this.lastLoginCommand,
  });

  HomeScreenUiState copyWith({UsuarioLoginResponse? usuarioLoginResponse}) {
    return HomeScreenUiState(
      usuarioLoginResponse: usuarioLoginResponse ?? this.usuarioLoginResponse,
      lastLoginCommand: lastLoginCommand,
    );
  }
}
