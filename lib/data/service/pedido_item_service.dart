import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tasko_mobile/config/config_api.dart';
import 'package:tasko_mobile/config/http_client_config.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoItemService {
  final ConfigApi _configApi;
  final http.Client _client;
  final String _path = '/api/v1/pedidos/itens';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  PedidoItemService({required ConfigApi configApi, required http.Client client})
    : _configApi = configApi,
      _client = client;

  Future<Result<PedidoItemResponse>> adicionar(
    AdicionarPedidoItemRequest request,
  ) async {
    final url = Uri.https(_configApi.baseUrl, _path);

    try {
      final response = await _client.post(
        url,
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      return convertToResult<PedidoItemResponse>(
        (decodedJson) => PedidoItemResponse.fromJson(decodedJson['data']),
        response,
      );
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<List<PedidoItemResponse>>> listarPorPedido(int pedidoId) async {
    final url = Uri.https(_configApi.baseUrl, _path, {
      'pedidoId': pedidoId.toString(),
    });

    try {
      final response = await _client.get(url, headers: _headers);
      return convertToResult<List<PedidoItemResponse>>((decodedJson) {
        final dynamic rawData = decodedJson['data'];
        final List<dynamic> list = rawData is List
            ? rawData
            : (rawData is Map<String, dynamic> && rawData['content'] is List)
            ? rawData['content'] as List<dynamic>
            : <dynamic>[];
        return list
            .map((e) => PedidoItemResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      }, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }

  Future<Result<void>> excluir(int itemId) async {
    final url = Uri.https(_configApi.baseUrl, '$_path/$itemId');
    try {
      final response = await _client.delete(url, headers: _headers);
      return convertToResult<void>((decodedJson) {}, response);
    } on Exception catch (error) {
      return Result.failure([error.toString()]);
    }
  }
}

final pedidoItemServiceProvider = Provider<PedidoItemService>((ref) {
  final configApi = ref.watch(configApiProvider);
  final httpClient = ref.watch(httpClientProvider);
  return PedidoItemService(configApi: configApi, client: httpClient);
});
