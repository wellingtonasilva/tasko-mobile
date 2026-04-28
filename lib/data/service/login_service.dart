import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/usuario/request/login_request.dart';
import 'package:tasko_mobile/domain/usuario/request/resetar_senha_request.dart';
import 'package:tasko_mobile/domain/usuario/request/solicitacao_recuperar_senha_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/util/result.dart';

class LoginService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/login';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  LoginService({required ConfigApi configApi, required http.Client client})
    : _configApi = configApi,
      _client = client;

  Future<Result<UsuarioLoginResponse>> login(LoginRequest request) async {
    final url = Uri.https(_configApi.baseUrl, _path);

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

  Future<Result<void>> solicitarRecuperacaoSenha(
    SolicitacaoRecuperarSenhaRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/recuperar-senha');

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<void>((_) {}, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> resetarSenha(ResetarSenhaRequest request) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/resetar-senha');

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<void>((_) {}, response);
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
