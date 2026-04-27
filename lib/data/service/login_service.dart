import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/usuario/request/login_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/util/result.dart';

class LoginService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  LoginService({required ConfigApi configApi, required http.Client client})
    : _configApi = configApi,
      _client = client;

  Future<Result<UsuarioLoginResponse>> login(LoginRequest request) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/login');

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<UsuarioLoginResponse>(
        (decodedJson) => UsuarioLoginResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final loginServiceProvider = Provider<LoginService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return LoginService(configApi: configApi, client: httpClient);
});
