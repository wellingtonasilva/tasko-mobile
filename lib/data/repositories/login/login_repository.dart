import 'package:tasko_mobile/domain/usuario/request/login_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class LoginRepository {
  Future<Result<UsuarioLoginResponse>> login(LoginRequest request);
}
