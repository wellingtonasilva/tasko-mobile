import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/resumo/pedido_adicionar_resumo_controllers.dart';

class PedidoAdicionarResumoScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoAdicionarResumoScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<PedidoAdicionarResumoScreen> createState() =>
      _PedidoAdicionarResumoScreenState();
}

class _PedidoAdicionarResumoScreenState
    extends BaseScreenState<PedidoAdicionarResumoScreen> {
  late final PedidoAdicionarResumoControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoAdicionarResumoControllers();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container();
  }
}
