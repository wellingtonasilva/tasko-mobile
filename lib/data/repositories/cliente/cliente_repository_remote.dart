import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository.dart';
import 'package:tasko_mobile/data/service/cliente_service.dart';
import 'package:tasko_mobile/data/service/cliente_tabela_preco_service.dart';
import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_tabela_preco_response.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteRepositoryRemote implements ClienteRepository {
  final ClienteService _service;
  final ClienteTabelaPrecoService _tabelaPrecoService;

  ClienteRepositoryRemote({
    required ClienteService service,
    required ClienteTabelaPrecoService tabelaPrecoService,
  }) : _service = service,
       _tabelaPrecoService = tabelaPrecoService;

  @override
  Future<Result<ClienteResponse>> adicionar(AdicionarClienteRequest request) {
    return _service.adicionar(request);
  }

  @override
  Future<Result<ClienteResponse>> atualizar(
    int id,
    AtualizarClienteRequest request,
  ) {
    return _service.atualizar(id, request);
  }

  @override
  Future<Result<void>> excluir(int id) {
    return _service.excluir(id);
  }

  @override
  Future<Result<List<ClienteResponse>>> listar({int? vendedorId}) async {
    final result = await _service.listar();
    if (result is! Success<List<ClienteResponse>>) {
      return result;
    }

    if (vendedorId == null) {
      return result;
    }

    final filtered = result.value
        .where((cliente) => cliente.vendedorId == vendedorId)
        .toList();
    return Result.success(filtered);
  }

  @override
  Future<Result<ClienteResponse>> obterPorId(int id) {
    return _service.obterPorId(id);
  }

  @override
  Future<Result<List<ClienteTabelaPrecoResponse>>> listarTabelasPreco(
    int clienteId,
  ) {
    return _tabelaPrecoService.listarPorCliente(clienteId);
  }
}

final clienteRepositoryRemoteProvider = Provider<ClienteRepositoryRemote>((
  ref,
) {
  final service = ref.watch(clienteServiceProvider);
  final tabelaPrecoService = ref.watch(clienteTabelaPrecoServiceProvider);
  return ClienteRepositoryRemote(
    service: service,
    tabelaPrecoService: tabelaPrecoService,
  );
});
