import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/login/login_repository.dart';
import 'package:tasko_mobile/data/service/login_service.dart';
import 'package:tasko_mobile/domain/usuario/request/login_request.dart';
import 'package:tasko_mobile/domain/usuario/request/resetar_senha_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/util/result.dart';
import 'package:tasko_mobile/domain/usuario/request/solicitacao_recuperar_senha_request.dart';

class LoginRepositoryRemote implements LoginRepository {
  final LoginService _service;

  LoginRepositoryRemote({required LoginService service}) : _service = service;

  @override
  Future<Result<UsuarioLoginResponse>> login(LoginRequest request) {
    return _service.login(request);
  }

  @override
  Future<Result<void>> solicitarRecuperacaoSenha(
    SolicitacaoRecuperarSenhaRequest request,
  ) {
    return _service.solicitarRecuperacaoSenha(request);
  }

  @override
  Future<Result<void>> resetarSenha(ResetarSenhaRequest request) {
    return _service.resetarSenha(request);
  }
}

final loginRepositoryRemoteProvider = Provider<LoginRepositoryRemote>((ref) {
  final service = ref.watch(loginServiceProvider);
  return LoginRepositoryRemote(service: service);
});
