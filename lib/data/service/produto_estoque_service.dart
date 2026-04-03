import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/produto/response/produto_estoque_localizacao_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoEstoqueService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/produtos/estoque';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ProdutoEstoqueService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<ProdutoEstoqueLocalizacaoResponse>>> listar({
    int? produtoId,
  }) async {
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
      return convertToResult<List<ProdutoEstoqueLocalizacaoResponse>>((
        decodedJson,
      ) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List ? rawData : <dynamic>[];

        final estoques = list
            .whereType<Map<String, dynamic>>()
            .map(ProdutoEstoqueLocalizacaoResponse.fromJson)
            .toList();

        if (produtoId == null) {
          return estoques;
        }

        return estoques.where((item) => item.produtoId == produtoId).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final produtoEstoqueServiceProvider = Provider<ProdutoEstoqueService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return ProdutoEstoqueService(configApi: configApi, client: httpClient);
});
