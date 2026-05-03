import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/data/repositories/cliente/cliente_repository_hybrid.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository_hybrid.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/cliente/pedido_criar_cliente_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pagamento/pedido_criar_pagamento_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_rascunho_ui_state.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/produto/pedido_criar_produto_view_model.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoCriarRascunhoViewModel
    extends Notifier<PedidoCriarRascunhoUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  PedidoCriarRascunhoUiState build() {
    return PedidoCriarRascunhoUiState(
      criarRascunhoCommand: Command1<PedidoResponse, AdicionarPedidoRequest>(
        _criarRascunho,
      ),
      atualizarRascunhoCommand:
          Command1<PedidoResponse, AtualizarPedidoRascunhoArgs>(
            _atualizarRascunho,
          ),
    );
  }

  Future<Result<PedidoResponse>> _criarRascunho(
    AdicionarPedidoRequest request,
  ) async {
    onStartEvent?.call();

    final result = await ref
        .read(pedidoRepositoryHybridProvider)
        .criarRascunho(request);

    if (result is Success<PedidoResponse>) {
      state = state.copyWith(pedido: result.value, isEdicao: false);
    } else if (result is Failure<PedidoResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'Erro ao criar rascunho do pedido',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }

  Future<Result<PedidoResponse>> _atualizarRascunho(
    AtualizarPedidoRascunhoArgs args,
  ) async {
    onStartEvent?.call();

    final result = await ref
        .read(pedidoRepositoryHybridProvider)
        .atualizarRascunho(
          args.pedidoId,
          args.request,
          itens: args.itens,
          formaPagamentoNome: args.formaPagamentoNome,
          condicaoPagamentoNome: args.condicaoPagamentoNome,
          pedidoStatusTipoNome: args.pedidoStatusTipoNome,
          substituirItens: args.substituirItens,
        );

    if (result is Success<PedidoResponse>) {
      state = state.copyWith(pedido: result.value);
    } else if (result is Failure<PedidoResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'Erro ao atualizar rascunho do pedido',
        result,
      );
    }

    onFinishEvent?.call();
    return result;
  }

  Future<void> carregarParaEdicao(int pedidoId) async {
    onStartEvent?.call();

    final pedidoResult = await ref
        .read(pedidoRepositoryHybridProvider)
        .obterPorId(pedidoId);

    if (pedidoResult is Failure<PedidoResponse>) {
      showSnackBar?.call(
        pedidoResult.errors?[0] ?? 'Erro ao carregar pedido para edição',
        pedidoResult,
      );
      onFinishEvent?.call();
      return;
    }

    final pedido = (pedidoResult as Success<PedidoResponse>).value;

    List<PedidoItemResponse> itens = pedido.itens;
    final itensResult = await ref
        .read(pedidoRepositoryHybridProvider)
        .listarItens(pedido.id);
    if (itensResult is Success<List<PedidoItemResponse>> &&
        itensResult.value.isNotEmpty) {
      itens = itensResult.value;
    }

    final pedidoComItens = PedidoResponse(
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
      itens: itens,
    );

    state = state.copyWith(pedido: pedidoComItens, isEdicao: true);

    final clienteResult = await ref
        .read(clienteRepositoryHybridProvider)
        .obterPorId(pedido.clienteId);

    if (clienteResult is Success<ClienteResponse>) {
      ref
          .read(pedidoCriarClienteViewModelProvider.notifier)
          .preencherCliente(clienteResult.value);
    }

    ref
        .read(pedidoCriarProdutoViewModelProvider.notifier)
        .preencherCarrinho(itens);

    ref
        .read(pedidoCriarPagamentoViewModelProvider.notifier)
        .preencherPagamento(
          pedido.formaPagamentoNome,
          pedido.condicaoPagamentoNome,
        );

    onFinishEvent?.call();
  }

  void limpar() {
    state = state.copyWith(clearPedido: true, isEdicao: false);
  }
}

final pedidoCriarRascunhoViewModelProvider =
    NotifierProvider<PedidoCriarRascunhoViewModel, PedidoCriarRascunhoUiState>(
      () => PedidoCriarRascunhoViewModel(),
    );
