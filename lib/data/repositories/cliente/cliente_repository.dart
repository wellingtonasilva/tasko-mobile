import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_tabela_preco_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class ClienteRepository {
  Future<Result<ClienteResponse>> adicionar(AdicionarClienteRequest request);
  Future<Result<ClienteResponse>> atualizar(
    int id,
    AtualizarClienteRequest request,
  );
  Future<Result<List<ClienteResponse>>> listar({int? vendedorId});
  Future<Result<ClienteResponse>> obterPorId(int id);
  Future<Result<void>> excluir(int id);
  Future<Result<List<ClienteTabelaPrecoResponse>>> listarTabelasPreco(
    int clienteId,
  );
}
