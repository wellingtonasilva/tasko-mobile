import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/checkins_tipo_response.dart';
import 'package:tasko_mobile/util/result.dart';

class CheckinsTipoService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/checkins/tipos';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  CheckinsTipoService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<List<CheckinsTipoResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<CheckinsTipoResponse>>((decodedJson) {
        final List<dynamic> data = decodedJson['data'];
        return data.map((e) => CheckinsTipoResponse.fromJson(e)).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<CheckinsTipoResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<CheckinsTipoResponse>(
        (decodedJson) => CheckinsTipoResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final checkinsTipoServiceProvider = Provider<CheckinsTipoService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return CheckinsTipoService(configApi: configApi, client: httpClient);
});
