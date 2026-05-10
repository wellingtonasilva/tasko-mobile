import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/common/core/auth_persistence.dart';
import 'package:tasko_mobile/data/repositories/pedido/pedido_repository_hybrid.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/request/atualizar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_rascunho_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/produto/pedido_criar_produto_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/resumo/pedido_criar_resumo_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoCriarResumoViewModel extends Notifier<PedidoCriarResumoUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;
  void Function()? onConfirmado;

  @override
  PedidoCriarResumoUiState build() {
    final rascunhoState = ref.watch(pedidoCriarRascunhoViewModelProvider);
    return PedidoCriarResumoUiState(
      confirmarCommand: Command0<void>(_confirmar),
      rascunho: rascunhoState.pedido,
      isEdicao: rascunhoState.isEdicao,
    );
  }

  Future<Result<PedidoResponse>> _confirmar() async {
    onStartEvent?.call();

    final rascunho = state.rascunho;
    if (rascunho == null) {
      final failure = Failure<PedidoResponse>(['Rascunho não encontrado']);
      onFinishEvent?.call();
      return failure;
    }

    final produtoState = ref.read(pedidoCriarProdutoViewModelProvider);
    final List<AdicionarPedidoItemRequest> itens = produtoState
        .carrinhoQuantidades
        .entries
        .map((e) {
          final produto = produtoState.produtos!.firstWhere(
            (p) => p.id == e.key,
          );
          final preco = produto.precoSugerido ?? 0;
          return AdicionarPedidoItemRequest(
            pedidoId: rascunho.id,
            produtoId: produto.id ?? 0,
            quantidade: e.value,
            precoUnitario: preco,
            valorTotal: preco * e.value,
          );
        })
        .toList();

    final subtotal = itens.fold(0.0, (s, i) => s + i.valorTotal);

    final Result<PedidoResponse> result;
    if (state.isEdicao) {
      final request = AtualizarPedidoRequest(
        id: rascunho.id,
        clienteId: rascunho.clienteId,
        vendedorId: rascunho.vendedorId,
        dataPedido: rascunho.dataPedido.toIso8601String(),
        subtotal: subtotal,
        valorTotal: subtotal,
        formaPagamentoId: rascunho.formaPagamentoId,
        condicaoPagamentoId: rascunho.condicaoPagamentoId,
        latitude: rascunho.latitude,
        longitude: rascunho.longitude,
        empresaId:
            (await ref.read(authLocalStorageProvider).getUsuarioLoginResponse())
                ?.empresas
                ?.firstOrNull
                ?.empresaId ??
            0,
      );
      result = await ref
          .read(pedidoRepositoryHybridProvider)
          .atualizar(
            rascunho.id,
            request,
            itens: itens,
            formaPagamentoNome: rascunho.formaPagamentoNome,
            condicaoPagamentoNome: rascunho.condicaoPagamentoNome,
          );
    } else {
      final request = AdicionarPedidoRequest(
        clienteId: rascunho.clienteId,
        vendedorId: rascunho.vendedorId,
        dataPedido: rascunho.dataPedido.toIso8601String(),
        subtotal: subtotal,
        valorTotal: subtotal,
        formaPagamentoId: rascunho.formaPagamentoId,
        condicaoPagamentoId: rascunho.condicaoPagamentoId,
        latitude: rascunho.latitude,
        longitude: rascunho.longitude,
        empresaId:
            (await ref.read(authLocalStorageProvider).getUsuarioLoginResponse())
                ?.empresas
                ?.firstOrNull
                ?.empresaId ??
            0,
      );
      result = await ref
          .read(pedidoRepositoryHybridProvider)
          .adicionar(
            request,
            itens: itens,
            formaPagamentoNome: rascunho.formaPagamentoNome,
            condicaoPagamentoNome: rascunho.condicaoPagamentoNome,
          );
    }

    if (result is Failure<PedidoResponse>) {
      showSnackBar?.call(
        result.errors?[0] ?? 'Erro ao confirmar pedido',
        result,
      );
    } else {
      onConfirmado?.call();
    }

    onFinishEvent?.call();
    return result;
  }
}

final pedidoCriarResumoViewModelProvider =
    NotifierProvider<PedidoCriarResumoViewModel, PedidoCriarResumoUiState>(
      () => PedidoCriarResumoViewModel(),
    );
