import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/produto/request/adicionar_produto_request.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/produtos';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ProdutoService({required ConfigApi configApi, required http.Client client})
    : _configApi = configApi,
      _client = client;

  Future<Result<ProdutoResponse>> adicionarProduto(
    AdicionarProdutoRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<ProdutoResponse>(
        (decodedJson) => ProdutoResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<ProdutoResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<ProdutoResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List ? rawData : <dynamic>[];

        return list
            .whereType<Map<String, dynamic>>()
            .map(ProdutoResponse.fromJson)
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ProdutoResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');

    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<ProdutoResponse>(
        (decodedJson) => ProdutoResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final produtoServiceProvider = Provider<ProdutoService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return ProdutoService(configApi: configApi, client: httpClient);
});
