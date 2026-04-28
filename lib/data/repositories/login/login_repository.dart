import 'package:tasko_mobile/domain/usuario/request/login_request.dart';
import 'package:tasko_mobile/domain/usuario/request/resetar_senha_request.dart';
import 'package:tasko_mobile/domain/usuario/request/solicitacao_recuperar_senha_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class LoginRepository {
  Future<Result<UsuarioLoginResponse>> login(LoginRequest request);
  Future<Result<void>> solicitarRecuperacaoSenha(
    SolicitacaoRecuperarSenhaRequest request,
  );
  Future<Result<void>> resetarSenha(ResetarSenhaRequest request);
}
