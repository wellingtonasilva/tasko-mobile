import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/login/login_repository_remote.dart';
import 'package:tasko_mobile/domain/usuario/request/solicitacao_recuperar_senha_request.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';
import 'recuperar_senha_ui_state.dart';

class RecuperarSenhaViewModel extends Notifier<RecuperarSenhaUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onRecuperarSenhaSucesso;

  @override
  RecuperarSenhaUiState build() {
    return RecuperarSenhaUiState(
      solicitarRecuperacaoSenhaCommand:
          Command1<void, SolicitacaoRecuperarSenhaRequest>(
            _solicitarRecuperacaoSenha,
          ),
    );
  }

  // RecuperarSenhaUiState

  Future<Result<void>> _solicitarRecuperacaoSenha(
    SolicitacaoRecuperarSenhaRequest request,
  ) async {
    final result = await ref
        .read(loginRepositoryRemoteProvider)
        .solicitarRecuperacaoSenha(request);

    if (result is Success<void>) {
      showSnackBar?.call('Recuperação de senha realizada com sucesso!', result);
      onRecuperarSenhaSucesso?.call();
    } else if (result is Failure<void>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    return result;
  }
}

final recuperarSenhaViewModelProvider =
    NotifierProvider<RecuperarSenhaViewModel, RecuperarSenhaUiState>(
      () => RecuperarSenhaViewModel(),
    );
