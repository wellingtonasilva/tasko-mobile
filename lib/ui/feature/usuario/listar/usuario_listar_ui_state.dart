import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/util/command.dart';

class UsuarioListarUiState {
  final List<UsuarioResponse> usuarios;
  final Command0<void> listarUsuariosCommand;
  final Command1<void, int> excluirUsuarioCommand;

  UsuarioListarUiState({
    required this.usuarios,
    required this.listarUsuariosCommand,
    required this.excluirUsuarioCommand,
  });

  UsuarioListarUiState copyWith({
    List<UsuarioResponse>? usuarios,
    Command0<void>? listarUsuariosCommand,
    Command1<void, int>? excluirUsuarioCommand,
  }) {
    return UsuarioListarUiState(
      usuarios: usuarios ?? this.usuarios,
      listarUsuariosCommand:
          listarUsuariosCommand ?? this.listarUsuariosCommand,
      excluirUsuarioCommand:
          excluirUsuarioCommand ?? this.excluirUsuarioCommand,
    );
  }
}
