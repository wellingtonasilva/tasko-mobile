import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/empresa/empresa_repository_remote.dart';
import 'package:tasko_mobile/domain/empresa/request/criar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/response/empresa_response.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/criar_conta/criar_conta_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class CriarContaViewModel extends Notifier<CriarContaUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onCriarContaComSucesso;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  CriarContaUiState build() {
    return CriarContaUiState(
      criarContaCommand: Command1<EmpresaResponse, CriarEmpresaRequest>(
        _criarEmpresa,
      ),
    );
  }

  Future<Result<EmpresaResponse>> _criarEmpresa(
    CriarEmpresaRequest request,
  ) async {
    onStartEvent?.call();
    final result = await ref
        .read(empresaRepositoryRemoteProvider)
        .criarEmpresa(request);
    if (result is Success<EmpresaResponse>) {
      showSnackBar?.call('Conta criada com sucesso!', result);
      onCriarContaComSucesso?.call();
    } else if (result is Failure<EmpresaResponse>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }
}

final criarContaViewModelProvider =
    NotifierProvider<CriarContaViewModel, CriarContaUiState>(
      () => CriarContaViewModel(),
    );
