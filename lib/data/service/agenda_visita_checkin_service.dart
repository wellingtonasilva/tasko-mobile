import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_checkin_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_checkin_response.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaCheckinService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/agenda-visitas/checkins';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  AgendaVisitaCheckinService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<AgendaVisitaCheckinResponse>> adicionar(
    AdicionarAgendaVisitaCheckinRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );
      return convertToResult<AgendaVisitaCheckinResponse>(
        (decodedJson) =>
            AgendaVisitaCheckinResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<AgendaVisitaCheckinResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<AgendaVisitaCheckinResponse>>((decodedJson) {
        final List<dynamic> data = decodedJson['data'];
        return data
            .map((e) => AgendaVisitaCheckinResponse.fromJson(e))
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaCheckinResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<AgendaVisitaCheckinResponse>(
        (decodedJson) =>
            AgendaVisitaCheckinResponse.fromJson(decodedJson['data']),
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
      return convertToResult<AgendaVisitaCheckinResponse>(
        (decodedJson) =>
            AgendaVisitaCheckinResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final agendaVisitaCheckinServiceProvider = Provider<AgendaVisitaCheckinService>(
  (ref) {
    final configApi = ref.watch(configApiProvider);
    final httpClient = ref.watch(httpClientProvider);
    return AgendaVisitaCheckinService(configApi: configApi, client: httpClient);
  },
);
