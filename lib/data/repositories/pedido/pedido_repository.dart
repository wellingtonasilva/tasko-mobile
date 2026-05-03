import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/request/atualizar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/util/result.dart';

abstract class PedidoRepository {
  Future<Result<PedidoResponse>> criarRascunho(
    AdicionarPedidoRequest request, {
    List<AdicionarPedidoItemRequest> itens = const [],
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
  });
  Future<Result<PedidoResponse>> atualizarRascunho(
    int pedidoId,
    AdicionarPedidoRequest request, {
    List<AdicionarPedidoItemRequest> itens = const [],
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
    bool substituirItens = false,
  });
  Future<Result<PedidoResponse>> adicionar(
    AdicionarPedidoRequest request, {
    required List<AdicionarPedidoItemRequest> itens,
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
  });
  Future<Result<PedidoResponse>> atualizar(
    int pedidoId,
    AtualizarPedidoRequest request, {
    required List<AdicionarPedidoItemRequest> itens,
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
  });
  Future<Result<List<PedidoResponse>>> listar({int? vendedorId});
  Future<Result<PedidoResponse>> obterPorId(int id);
  Future<Result<void>> excluir(int id);
  Future<Result<PedidoItemResponse>> adicionarItem(
    AdicionarPedidoItemRequest request,
  );
  Future<Result<List<PedidoItemResponse>>> listarItens(int pedidoId);
  Future<Result<void>> excluirItem(int itemId);
}
