import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/cliente/pedido_adicionar_cliente_controllers.dart';

class PedidoAdicionarClienteScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoAdicionarClienteScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<PedidoAdicionarClienteScreen> createState() =>
      _PedidoAdicionarClienteScreenState();
}

class _PedidoAdicionarClienteScreenState
    extends BaseScreenState<PedidoAdicionarClienteScreen> {
  late final PedidoAdicionarClienteControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoAdicionarClienteControllers();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container();
  }
}
