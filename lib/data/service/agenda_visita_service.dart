import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/atualizar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/agenda-visitas';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  AgendaVisitaService({
    required ConfigApi configApi,
    required http.Client client,
  }) : _configApi = configApi,
       _client = client;

  Future<Result<AgendaVisitaResponse>> adicionar(
    AdicionarAgendaVisitaRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );
      return convertToResult<AgendaVisitaResponse>(
        (decodedJson) => AgendaVisitaResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaResponse>> atualizar(
    int id,
    AtualizarAgendaVisitaRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.put(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );
      return convertToResult<AgendaVisitaResponse>(
        (decodedJson) => AgendaVisitaResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<AgendaVisitaResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<AgendaVisitaResponse>>((decodedJson) {
        final List<dynamic> data = decodedJson['data'];
        return data.map((e) => AgendaVisitaResponse.fromJson(e)).toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<AgendaVisitaResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<AgendaVisitaResponse>(
        (decodedJson) => AgendaVisitaResponse.fromJson(decodedJson['data']),
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
      return convertToResult<AgendaVisitaResponse>(
        (decodedJson) => AgendaVisitaResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final agendaVisitaServiceProvider = Provider<AgendaVisitaService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return AgendaVisitaService(configApi: configApi, client: httpClient);
});
