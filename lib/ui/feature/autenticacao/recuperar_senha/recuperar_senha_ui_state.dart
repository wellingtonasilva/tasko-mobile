import 'package:tasko_mobile/domain/usuario/request/solicitacao_recuperar_senha_request.dart';
import 'package:tasko_mobile/util/result.dart';
import 'package:tasko_mobile/util/command.dart';

class RecuperarSenhaUiState {
  final Command1<void, SolicitacaoRecuperarSenhaRequest>
  solicitarRecuperacaoSenhaCommand;
  final Result<void>? resultadoSolicitacao;

  RecuperarSenhaUiState({
    required this.solicitarRecuperacaoSenhaCommand,
    this.resultadoSolicitacao,
  });

  RecuperarSenhaUiState copyWith({
    Command1<void, SolicitacaoRecuperarSenhaRequest>?
    solicitarRecuperacaoSenhaCommand,
    Result<void>? resultadoSolicitacao,
  }) {
    return RecuperarSenhaUiState(
      solicitarRecuperacaoSenhaCommand:
          solicitarRecuperacaoSenhaCommand ??
          this.solicitarRecuperacaoSenhaCommand,
      resultadoSolicitacao: resultadoSolicitacao ?? this.resultadoSolicitacao,
    );
  }
}

//
