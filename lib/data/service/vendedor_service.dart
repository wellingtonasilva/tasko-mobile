import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_request.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/vendedores';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  VendedorService({required ConfigApi configApi, required http.Client client})
    : _configApi = configApi,
      _client = client;

  Future<Result<VendedorResponse>> adicionar(
    AdicionarVendedorRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<VendedorResponse>(
        (decodedJson) => VendedorResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<VendedorResponse>> atualizar(
    int id,
    AtualizarVendedorRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');

    try {
      final response = await _client.put(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<VendedorResponse>(
        (decodedJson) => VendedorResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<VendedorResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<VendedorResponse>>((decodedJson) {
        final List<dynamic> data = decodedJson['data'];
        return data.map((e) => VendedorResponse.fromJson(e)).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<VendedorResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<VendedorResponse>(
        (decodedJson) => VendedorResponse.fromJson(decodedJson['data']),
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
      return convertToResult<VendedorResponse>(
        (decodedJson) => VendedorResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final vendedorServiceProvider = Provider<VendedorService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return VendedorService(configApi: configApi, client: httpClient);
});
