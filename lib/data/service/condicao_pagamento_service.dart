import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/pedido/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/util/result.dart';

class CondicaoPagamentoService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/condicoes-pagamento';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  CondicaoPagamentoService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<CondicaoPagamentoResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<CondicaoPagamentoResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List
            ? rawData
            : (rawData is Map<String, dynamic> && rawData['content'] is List)
            ? rawData['content'] as List<dynamic>
            : <dynamic>[];
        return list
            .map(
              (e) =>
                  CondicaoPagamentoResponse.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final condicaoPagamentoServiceProvider = Provider<CondicaoPagamentoService>((
  ref,
) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return CondicaoPagamentoService(configApi: configApi, client: httpClient);
});
