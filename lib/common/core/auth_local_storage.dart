import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';

class AuthLocalStorage {
  static const _tokenKey = 'auth_token';
  static const _empresaIdKey = 'empresa_id';
  static const _loginDataKey = 'login_data';

  /// Salva o objeto completo de login como JSON.
  /// Mantém [_tokenKey] e [_empresaIdKey] como chaves individuais
  /// para compatibilidade com o [AuthHttpClient].
  Future<void> saveLoginData(UsuarioLoginResponse loginData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginDataKey, json.encode(loginData.toJson()));
    // Mantém chaves individuais usadas pelo AuthHttpClient
    await prefs.setString(_tokenKey, loginData.token);
    if (loginData.empresas.isNotEmpty) {
      await prefs.setInt(_empresaIdKey, loginData.empresas.first.empresaId);
    }
  }

  Future<UsuarioLoginResponse?> getUsuarioLoginResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_loginDataKey);
    if (jsonStr == null) return null;
    return UsuarioLoginResponse.fromJson(
      json.decode(jsonStr) as Map<String, dynamic>,
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_empresaIdKey);
    await prefs.remove(_loginDataKey);
  }
}

final authLocalStorageProvider = Provider<AuthLocalStorage>((ref) {
  return AuthLocalStorage();
});
