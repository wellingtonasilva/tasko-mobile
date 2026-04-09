import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaStatusService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/agenda-visitas/status';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  AgendaVisitaStatusService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<AgendaVisitaStatusResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<AgendaVisitaStatusResponse>>((decodedJson) {
        final List<dynamic> data = decodedJson['data'];
        return data.map((e) => AgendaVisitaStatusResponse.fromJson(e)).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaStatusResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<AgendaVisitaStatusResponse>(
        (decodedJson) =>
            AgendaVisitaStatusResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final agendaVisitaStatusServiceProvider = Provider<AgendaVisitaStatusService>((
  ref,
) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return AgendaVisitaStatusService(configApi: configApi, client: httpClient);
});
