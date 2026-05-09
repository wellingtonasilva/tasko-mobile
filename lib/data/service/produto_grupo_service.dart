import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/grupo/request/adicionar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/request/atualizar_produto_grupo_request.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoGrupoService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/produtos/grupos';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ProdutoGrupoService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<ProdutoGrupoResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<ProdutoGrupoResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List ? rawData : <dynamic>[];

        return list
            .whereType<Map<String, dynamic>>()
            .map(ProdutoGrupoResponse.fromJson)
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ProdutoGrupoResponse>> adicionar(
    AdicionarProdutoGrupoRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<ProdutoGrupoResponse>(
        (decodedJson) => ProdutoGrupoResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ProdutoGrupoResponse>> atualizar(
    int id,
    AtualizarProdutoGrupoRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');

    try {
      final response = await _client.put(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<ProdutoGrupoResponse>(
        (decodedJson) => ProdutoGrupoResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<ProdutoGrupoResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<ProdutoGrupoResponse>(
        (decodedJson) => ProdutoGrupoResponse.fromJson(decodedJson['data']),
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
      return convertToResult<ProdutoGrupoResponse>(
        (decodedJson) => ProdutoGrupoResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final produtoGrupoServiceProvider = Provider<ProdutoGrupoService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return ProdutoGrupoService(configApi: configApi, client: httpClient);
});
