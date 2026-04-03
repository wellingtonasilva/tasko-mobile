import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/produto/response/produto_codigo_barras_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoCodigoBarrasService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/produtos/codigos-barras-tipos';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ProdutoCodigoBarrasService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<ProdutoCodigoBarrasResponse>>> listar({
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
      return convertToResult<List<ProdutoCodigoBarrasResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List ? rawData : <dynamic>[];

        final codigos = list
            .whereType<Map<String, dynamic>>()
            .map(ProdutoCodigoBarrasResponse.fromJson)
            .toList();

        if (produtoId == null) {
          return codigos;
        }

        return codigos.where((item) => item.produtoId == produtoId).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final produtoCodigoBarrasServiceProvider = Provider<ProdutoCodigoBarrasService>(
  (ref) {
    final configApi = ref.watch(configApiProvider);
    final httpClient = ref.watch(httpClientProvider);
    return ProdutoCodigoBarrasService(configApi: configApi, client: httpClient);
  },
);
