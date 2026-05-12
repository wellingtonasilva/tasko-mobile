import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';
import 'package:tasko_mobile/data/repositories/produto/produto_repository_hybrid.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/produto/pedido_criar_produto_ui_state.dart';
import 'package:tasko_mobile/util/command.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoCriarProdutoViewModel extends Notifier<PedidoCriarProdutoUiState> {
  void Function(String, Result result)? showSnackBar;
  void Function()? onStartEvent;
  void Function()? onFinishEvent;

  @override
  PedidoCriarProdutoUiState build() {
    return PedidoCriarProdutoUiState(
      listarProdutoCommand: Command0<void>(_listarProdutos),
    );
  }

  Future<Result<List<ProdutoResponse>>> _listarProdutos() async {
    onStartEvent?.call();
    final result = await ref.read(produtoRepositoryHybridProvider).listar();
    if (result is Success<List<ProdutoResponse>>) {
      state = state.copyWith(produtos: result.value);
    } else if (result is Failure<List<ProdutoResponse>>) {
      showSnackBar?.call(
        (result).errors?[0] ?? 'An unknown error occurred',
        result,
      );
    }
    onFinishEvent?.call();
    return result;
  }

  void setQuantidade(int produtoId, double quantidade) {
    final updated = Map<int, double>.from(state.carrinhoQuantidades);
    if (quantidade <= 0) {
      updated.remove(produtoId);
    } else {
      updated[produtoId] = quantidade;
    }
    state = state.copyWith(carrinhoQuantidades: updated);
  }

  void preencherCarrinho(List<PedidoItemResponse> itens) {
    final quantidades = <int, double>{
      for (final item in itens) item.produtoId: item.quantidade,
    };
    state = state.copyWith(carrinhoQuantidades: quantidades);
  }

  void limparCarrinho() {
    state = state.copyWith(carrinhoQuantidades: {});
  }
}

final pedidoCriarProdutoViewModelProvider =
    NotifierProvider<PedidoCriarProdutoViewModel, PedidoCriarProdutoUiState>(
      () => PedidoCriarProdutoViewModel(),
    );
