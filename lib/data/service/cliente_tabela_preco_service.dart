import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_tabela_preco_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteTabelaPrecoService {
  final ConfigApi _configApi;
  final http.Client _client;
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  ClienteTabelaPrecoService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<ClienteTabelaPrecoResponse>>> listarPorCliente(
    int clienteId,
  ) async {
    final url = Uri.https(
      _configApi.baseUrl,
      '/api/v1/clientes/$clienteId/tabelas-preco',
    );

    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<ClienteTabelaPrecoResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List ? rawData : <dynamic>[];

        return list
            .map(
              (e) => ClienteTabelaPrecoResponse.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final clienteTabelaPrecoServiceProvider = Provider<ClienteTabelaPrecoService>((
  ref,
) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return ClienteTabelaPrecoService(configApi: configApi, client: httpClient);
});
