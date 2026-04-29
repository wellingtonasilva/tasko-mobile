import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Um client HTTP que adiciona automaticamente o token e o código da empresa nos headers das requisições protegidas.
class AuthHttpClient extends http.BaseClient {
  final http.Client _inner;
  final List<String> _publicPaths;

  AuthHttpClient(this._inner, {List<String>? publicPaths})
    : _publicPaths =
          publicPaths ?? const ['/api/v1/empresas/criar', '/api/v1/login'];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Não adiciona headers extras para rotas públicas
    if (!_isPublic(request.url.path)) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final empresaId = prefs.getInt('empresa_id');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      if (empresaId != null) {
        request.headers['X-Empresa-Id'] = empresaId.toString();
      }
    }
    return _inner.send(request);
  }

  bool _isPublic(String path) {
    // Permite qualquer rota que comece com /api/v1/login
    if (path.startsWith('/api/v1/login')) return true;
    return _publicPaths.contains(path);
  }
}
