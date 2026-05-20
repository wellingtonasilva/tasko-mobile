import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';

class PedidoAdicionarProdutoScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoAdicionarProdutoScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<PedidoAdicionarProdutoScreen> createState() =>
      PedidoAdicionarProdutoScreenState();
}

class PedidoAdicionarProdutoScreenState
    extends BaseScreenState<PedidoAdicionarProdutoScreen> {
  @override
  Widget buildContent(BuildContext context) {
    return Container();
  }
}
