import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorTerritorioService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/territorios';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  VendedorTerritorioService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<VendedorTerritorioResponse>> adicionar(
    AdicionarVendedorTerritorioRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<VendedorTerritorioResponse>(
        (decodedJson) =>
            VendedorTerritorioResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<VendedorTerritorioResponse>> atualizar(
    int id,
    AtualizarVendedorTerritorioRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');

    try {
      final response = await _client.put(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<VendedorTerritorioResponse>(
        (decodedJson) =>
            VendedorTerritorioResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<VendedorTerritorioResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<VendedorTerritorioResponse>>((decodedJson) {
        final List<dynamic> data = decodedJson['data'];
        return data.map((e) => VendedorTerritorioResponse.fromJson(e)).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<VendedorTerritorioResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<VendedorTerritorioResponse>(
        (decodedJson) =>
            VendedorTerritorioResponse.fromJson(decodedJson['data']),
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
      return convertToResult<VendedorTerritorioResponse>(
        (decodedJson) =>
            VendedorTerritorioResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final vendedorTerritorioServiceProvider = Provider<VendedorTerritorioService>((
  ref,
) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return VendedorTerritorioService(configApi: configApi, client: httpClient);
});
