import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pagamento/pedido_adicionar_produto_controllers.dart';

class PedidoAdicionarPagamentoScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoAdicionarPagamentoScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<PedidoAdicionarPagamentoScreen> createState() =>
      _PedidoAdicionarPagamentoScreenState();
}

class _PedidoAdicionarPagamentoScreenState
    extends BaseScreenState<PedidoAdicionarPagamentoScreen> {
  late final PedidoAdicionarProdutoControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoAdicionarProdutoControllers();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container();
  }
}
