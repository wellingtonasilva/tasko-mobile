import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoCriarProdutoUiState {
  final Command0<void> listarProdutoCommand;
  List<ProdutoResponse>? produtos;
  // produtoId → quantidade
  final Map<int, double> carrinhoQuantidades;

  PedidoCriarProdutoUiState({
    required this.listarProdutoCommand,
    this.produtos,
    Map<int, double>? carrinhoQuantidades,
  }) : carrinhoQuantidades = carrinhoQuantidades ?? {};

  int get totalItens =>
      carrinhoQuantidades.values.fold(0, (sum, q) => sum + q.toInt());

  double get valorTotal {
    if (produtos == null) return 0;
    double total = 0;
    for (final entry in carrinhoQuantidades.entries) {
      final produto = produtos!.firstWhere(
        (p) => p.id == entry.key,
        orElse: () => produtos!.first,
      );
      total += (produto.precoSugerido ?? 0) * entry.value;
    }
    return total;
  }

  PedidoCriarProdutoUiState copyWith({
    Command0<void>? listarProdutoCommand,
    List<ProdutoResponse>? produtos,
    Map<int, double>? carrinhoQuantidades,
  }) {
    return PedidoCriarProdutoUiState(
      listarProdutoCommand: listarProdutoCommand ?? this.listarProdutoCommand,
      produtos: produtos ?? this.produtos,
      carrinhoQuantidades: carrinhoQuantidades ?? this.carrinhoQuantidades,
    );
  }
}
