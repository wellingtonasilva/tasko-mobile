import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/produto/response/produto_preco_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoPrecoService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/produtos/precos';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ProdutoPrecoService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<ProdutoPrecoResponse>>> listar({int? produtoId}) async {
    final query = <String, String>{};
    if (produtoId != null) {
      query['produtoId'] = produtoId.toString();
    }

    final url = Uri.https(
      _configApi.baseUrl,
      _path,
      query.isEmpty ? null : query,
    );

    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<ProdutoPrecoResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List ? rawData : <dynamic>[];

        final precos = list
            .whereType<Map<String, dynamic>>()
            .map(ProdutoPrecoResponse.fromJson)
            .toList();

        if (produtoId == null) {
          return precos;
        }

        return precos.where((item) => item.produtoId == produtoId).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final produtoPrecoServiceProvider = Provider<ProdutoPrecoService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return ProdutoPrecoService(configApi: configApi, client: httpClient);
});
