import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/usuario/request/adicionar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/request/atualizar_usuario_request.dart';
import 'package:tasko_mobile/domain/usuario/request/login_request.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_login_response.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/util/result.dart';

class UsuarioService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/usuarios';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  UsuarioService({required ConfigApi configApi, required http.Client client})
    : _configApi = configApi,
      _client = client;

  Future<Result<List<UsuarioResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.get(url, headers: _headers);

      return convertToResult<List<UsuarioResponse>>(
        (decodedJson) => (decodedJson['data'] as List)
            .map((item) => UsuarioResponse.fromJson(item))
            .toList(),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<UsuarioResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');

    try {
      final response = await _client.get(url, headers: _headers);

      return convertToResult<UsuarioResponse>(
        (decodedJson) => UsuarioResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> excluir(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');

    try {
      final response = await _client.delete(url, headers: _headers);

      return convertToResult<void>((_) {}, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<UsuarioResponse>> adicionar(
    AdicionarUsuarioRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<UsuarioResponse>(
        (decodedJson) => UsuarioResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<UsuarioResponse>> atualizar(
    int id,
    AtualizarUsuarioRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');

    try {
      final response = await _client.put(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<UsuarioResponse>(
        (decodedJson) => UsuarioResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final usuarioServiceProvider = Provider<UsuarioService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final client = ref.watch(httpClientProvider);
  return UsuarioService(configApi: configApi, client: client);
});
