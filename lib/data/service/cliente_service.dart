import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/clientes';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ClienteService({required ConfigApi configApi, required http.Client client})
    : _configApi = configApi,
      _client = client;

  Future<Result<ClienteResponse>> adicionar(
    AdicionarClienteRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<ClienteResponse>(
        (decodedJson) => ClienteResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ClienteResponse>> atualizar(
    int id,
    AtualizarClienteRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');

    try {
      final response = await _client.put(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<ClienteResponse>(
        (decodedJson) => ClienteResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<ClienteResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<ClienteResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List
            ? rawData
            : (rawData is Map<String, dynamic> && rawData['content'] is List)
            ? rawData['content'] as List<dynamic>
            : <dynamic>[];
        return list
            .map((e) => ClienteResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ClienteResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<ClienteResponse>(
        (decodedJson) => ClienteResponse.fromJson(decodedJson['data']),
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
      return convertToResult<void>((decodedJson) {}, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final clienteServiceProvider = Provider<ClienteService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return ClienteService(configApi: configApi, client: httpClient);
});
