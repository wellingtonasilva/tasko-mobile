import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/produto/response/produto_unidade_medida_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoUnidadeMedidaService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/produtos/unidades-medida';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ProdutoUnidadeMedidaService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<ProdutoUnidadeMedidaResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<ProdutoUnidadeMedidaResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List ? rawData : <dynamic>[];

        return list
            .whereType<Map<String, dynamic>>()
            .map(ProdutoUnidadeMedidaResponse.fromJson)
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final produtoUnidadeMedidaServiceProvider =
    Provider<ProdutoUnidadeMedidaService>((ref) {
      final configApi = ref.watch(configApiProvider);
      final httpClient = ref.watch(httpClientProvider);
      return ProdutoUnidadeMedidaService(
        configApi: configApi,
        client: httpClient,
      );
    });
