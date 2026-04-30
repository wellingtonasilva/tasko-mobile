import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/produto/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoSubgrupoService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/produtos/subgrupos';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ProdutoSubgrupoService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<ProdutoSubgrupoResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<ProdutoSubgrupoResponse>>((decodedJson) {
        final List<dynamic> data = decodedJson['data'];
        return data.map((e) => ProdutoSubgrupoResponse.fromJson(e)).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final produtoSubgrupoServiceProvider = Provider<ProdutoSubgrupoService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return ProdutoSubgrupoService(configApi: configApi, client: httpClient);
});
