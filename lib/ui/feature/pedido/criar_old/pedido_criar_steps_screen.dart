import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pedido_criar_rascunho_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pedido_criar_steps_controllers.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/cliente/pedido_criar_cliente_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/produto/pedido_criar_produto_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pagamento/pedido_criar_pagamento_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/resumo/pedido_criar_resumo_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/sucesso/pedido_criar_sucesso_screen.dart';

class PedidoCriarStepsScreen extends BaseScreen {
  final int? pedidoId;

  const PedidoCriarStepsScreen({super.key, this.pedidoId});

  @override
  BaseScreenState<PedidoCriarStepsScreen> createState() =>
      _PedidoCriarStepsScreenState();
}

class _PedidoCriarStepsScreenState
    extends BaseScreenState<PedidoCriarStepsScreen> {
  late PedidoCriarStepsControllers _controllers;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoCriarStepsControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final draftNotifier = ref.read(
        pedidoCriarRascunhoViewModelProvider.notifier,
      );

      draftNotifier.resetFluxoCompleto();

      if (widget.pedidoId != null) {
        await draftNotifier.carregarParaEdicao(widget.pedidoId!);
      }
    });
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PageView(
        controller: _controllers.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          PedidoCriarClienteScreen(
            onPrevious: (cliente) => context.pop(),
            onNext: (cliente) {
              nextStep();
            },
          ),
          PedidoCriarProdutoScreen(
            onPrevious: (produto) => prevStep(),
            onNext: (produto) {
              nextStep();
            },
          ),
          PedidoCriarPagamentoScreen(
            onPrevious: (pagamento) => prevStep(),
            onNext: (pagamento) {
              nextStep();
            },
          ),
          PedidoCriarResumoScreen(
            onPrevious: (resumo) => prevStep(),
            onNext: (resumo) {
              nextStep();
            },
          ),
          PedidoCriarSucessoScreen(),
        ],
      ),
    );
  }

  void nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
      _controllers.pageController.nextPage(
        duration: Duration(milliseconds: 10),
        curve: Curves.ease,
      );
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _controllers.pageController.previousPage(
        duration: Duration(milliseconds: 10),
        curve: Curves.ease,
      );
    }
  }
}
