import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/auth_local_storage.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';

final authLocalStorageProvider = Provider<AuthLocalStorage>(
  (ref) => AuthLocalStorage(),
);

Future<void> persistLoginData(
  UsuarioLoginResponse response,
  AuthLocalStorage storage,
) async {
  await storage.saveToken(response.token);

  if (response.empresas.isNotEmpty) {
    await storage.saveEmpresaId(response.empresas.first.empresaId);
  }
}
