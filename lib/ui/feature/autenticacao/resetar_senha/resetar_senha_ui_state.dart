import 'package:tasko_mobile/domain/usuario/request/resetar_senha_request.dart';
import 'package:tasko_mobile/util/command.dart';

class ResetarSenhaUiState {
  final Command1<void, ResetarSenhaRequest> resetarSenhaCommand;

  ResetarSenhaUiState({required this.resetarSenhaCommand});

  ResetarSenhaUiState copyWith({
    Command1<void, ResetarSenhaRequest>? resetarSenhaCommand,
  }) {
    return ResetarSenhaUiState(
      resetarSenhaCommand: resetarSenhaCommand ?? this.resetarSenhaCommand,
    );
  }
}
