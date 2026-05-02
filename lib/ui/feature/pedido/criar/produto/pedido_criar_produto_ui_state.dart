import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/util/command.dart';

class PedidoCriarProdutoUiState {
  // Produtos
  final Command0<void> listarProdutoCommand;
  List<ProdutoResponse>? produtos;
  ProdutoResponse? selectedProduto;

  PedidoCriarProdutoUiState({
    required this.listarProdutoCommand,
    this.produtos,
    this.selectedProduto,
  });

  PedidoCriarProdutoUiState copyWith({
    Command0<void>? listarProdutoCommand,
    List<ProdutoResponse>? produtos,
    ProdutoResponse? selectedProduto,
  }) {
    return PedidoCriarProdutoUiState(
      listarProdutoCommand: listarProdutoCommand ?? this.listarProdutoCommand,
      produtos: produtos ?? this.produtos,
      selectedProduto: selectedProduto ?? this.selectedProduto,
    );
  }
}
