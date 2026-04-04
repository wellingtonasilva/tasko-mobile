import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository.dart';
import 'package:tasko_mobile/data/service/pedido_item_service.dart';
import 'package:tasko_mobile/data/service/pedido_service.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoRepositoryRemote implements PedidoRepository {
  final PedidoService _pedidoService;
  final PedidoItemService _pedidoItemService;

  PedidoRepositoryRemote({
    required PedidoService pedidoService,
    required PedidoItemService pedidoItemService,
  }) : _pedidoService = pedidoService,
       _pedidoItemService = pedidoItemService;

  @override
  Future<Result<PedidoResponse>> adicionar(
    AdicionarPedidoRequest request, {
    required List<AdicionarPedidoItemRequest> itens,
    String? formaPagamentoNome,
    String? condicaoPagamentoNome,
    String? pedidoStatusTipoNome,
  }) async {
    final pedidoResult = await _pedidoService.adicionar(request);
    if (pedidoResult is! Success<PedidoResponse>) {
      return pedidoResult;
    }

    final pedido = pedidoResult.value;
    final createdItens = <PedidoItemResponse>[];

    for (final item in itens) {
      final itemRequest = AdicionarPedidoItemRequest(
        pedidoId: pedido.id,
        produtoId: item.produtoId,
        quantidade: item.quantidade,
        precoUnitario: item.precoUnitario,
        percentualDesconto: item.percentualDesconto,
        valorDesconto: item.valorDesconto,
        valorTotal: item.valorTotal,
      );

      final itemResult = await _pedidoItemService.adicionar(itemRequest);
      if (itemResult is Success<PedidoItemResponse>) {
        createdItens.add(itemResult.value);
      }
    }

    return Result.success(
      PedidoResponse(
        id: pedido.id,
        numeroPedido: pedido.numeroPedido,
        clienteId: pedido.clienteId,
        vendedorId: pedido.vendedorId,
        pedidoStatusTipoId: pedido.pedidoStatusTipoId,
        pedidoStatusTipoNome: pedido.pedidoStatusTipoNome,
        dataPedido: pedido.dataPedido,
        dataEntregaPrevista: pedido.dataEntregaPrevista,
        observacao: pedido.observacao,
        subtotal: pedido.subtotal,
        percentualDesconto: pedido.percentualDesconto,
        valorDesconto: pedido.valorDesconto,
        valorFrete: pedido.valorFrete,
        valorTotal: pedido.valorTotal,
        formaPagamentoId: pedido.formaPagamentoId,
        formaPagamentoNome: pedido.formaPagamentoNome,
        condicaoPagamentoId: pedido.condicaoPagamentoId,
        condicaoPagamentoNome: pedido.condicaoPagamentoNome,
        latitude: pedido.latitude,
        longitude: pedido.longitude,
        sincronizado: pedido.sincronizado,
        criadoOffline: pedido.criadoOffline,
        uuidOffline: pedido.uuidOffline,
        auditoria: pedido.auditoria,
        itens: createdItens,
      ),
    );
  }

  @override
  Future<Result<List<PedidoResponse>>> listar({int? vendedorId}) async {
    final result = await _pedidoService.listar();
    if (result is! Success<List<PedidoResponse>>) {
      return result;
    }

    if (vendedorId == null) {
      return result;
    }

    final filtered = result.value
        .where((pedido) => pedido.vendedorId == vendedorId)
        .toList();
    return Result.success(filtered);
  }

  @override
  Future<Result<PedidoResponse>> obterPorId(int id) {
    return _pedidoService.obterPorId(id);
  }

  @override
  Future<Result<void>> excluir(int id) {
    return _pedidoService.excluir(id);
  }

  @override
  Future<Result<PedidoItemResponse>> adicionarItem(
    AdicionarPedidoItemRequest request,
  ) {
    return _pedidoItemService.adicionar(request);
  }

  @override
  Future<Result<List<PedidoItemResponse>>> listarItens(int pedidoId) {
    return _pedidoItemService.listarPorPedido(pedidoId);
  }

  @override
  Future<Result<void>> excluirItem(int itemId) {
    return _pedidoItemService.excluir(itemId);
  }
}

final pedidoRepositoryRemoteProvider = Provider<PedidoRepositoryRemote>((ref) {
  final pedidoService = ref.watch(pedidoServiceProvider);
  final pedidoItemService = ref.watch(pedidoItemServiceProvider);
  return PedidoRepositoryRemote(
    pedidoService: pedidoService,
    pedidoItemService: pedidoItemService,
  );
});
