import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasko_mobile/data/service/forma_pagamento_service.dart';

class AuthLocalStorage {
  static const _tokenKey = 'auth_token';
  static const _empresaIdKey = 'empresa_id';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveEmpresaId(int empresaId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_empresaIdKey, empresaId);
  }

  Future<int?> getEmpresaId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_empresaIdKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_empresaIdKey);
  }
}

final authLocalStorageProvider = Provider<AuthLocalStorage>((ref) {
  return AuthLocalStorage();
});
