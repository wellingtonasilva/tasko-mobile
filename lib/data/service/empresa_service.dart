import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/empresa/request/adicionar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/request/atualizar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/request/criar_empresa_request.dart';
import 'package:tasko_mobile/domain/empresa/response/empresa_response.dart';
import 'package:tasko_mobile/util/result.dart';

class EmpresaService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/empresas';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  EmpresaService({required ConfigApi configApi, required http.Client client})
    : _configApi = configApi,
      _client = client;

  Future<Result<List<EmpresaResponse>>> listar() async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<EmpresaResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List
            ? rawData
            : (rawData is Map<String, dynamic> && rawData['content'] is List)
            ? rawData['content'] as List<dynamic>
            : <dynamic>[];
        return list
            .map((e) => EmpresaResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<EmpresaResponse>> obterPorId(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<EmpresaResponse>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        if (rawData is Map<String, dynamic>) {
          return EmpresaResponse.fromJson(rawData);
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> excluir(int id) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.delete(url, headers: _headers);
      return convertToResult<void>((_) => null, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<EmpresaResponse>> adicionar(
    AdicionarEmpresaRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);
    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: request.toJson(),
      );
      return convertToResult<EmpresaResponse>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        if (rawData is Map<String, dynamic>) {
          return EmpresaResponse.fromJson(rawData);
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<EmpresaResponse>> criarEmpresa(
    CriarEmpresaRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/criar');
    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: request.toJson(),
      );
      return convertToResult<EmpresaResponse>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        if (rawData is Map<String, dynamic>) {
          return EmpresaResponse.fromJson(rawData);
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<EmpresaResponse>> atualizar(
    int id,
    AtualizarEmpresaRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$id');
    try {
      final response = await _client.put(
        url,
        headers: _headers,
        body: request.toJson(),
      );
      return convertToResult<EmpresaResponse>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        if (rawData is Map<String, dynamic>) {
          return EmpresaResponse.fromJson(rawData);
        } else {
          throw Exception('Formato de resposta inesperado');
        }
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final empresaServiceProvider = Provider<EmpresaService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return EmpresaService(configApi: configApi, client: httpClient);
});
