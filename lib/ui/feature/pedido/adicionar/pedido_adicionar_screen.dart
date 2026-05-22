import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/cliente/pedido_adicionar_cliente_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pagamento/pedido_adicionar_pagamento_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pedido_adicionar_controllers.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pedido_adicionar_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/produto/pedido_adicionar_produto_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/resumo/pedido_adicionar_resumo_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/sucesso/pedido_adicionar_sucesso_screen.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoAdicionarScreen extends BaseScreen {
  const PedidoAdicionarScreen({super.key});

  @override
  BaseScreenState<PedidoAdicionarScreen> createState() =>
      _PedidoAdicionarScreenState();
}

class _PedidoAdicionarScreenState
    extends BaseScreenState<PedidoAdicionarScreen> {
  late final PedidoAdicionarControllers _controllers;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoAdicionarControllers();

    final viewModel = ref.read(pedidoAdicionarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };

    viewModel.onAdicionarSucesso = () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    };

    viewModel.onStartEvent = () {
      if (mounted) {
        showLoading();
      }
    };
    viewModel.onFinishEvent = () {
      if (mounted) {
        hideLoading();
      }
    };

    ref.read(pedidoAdicionarViewModelProvider).listarClienteCommand.execute();
    ref.read(pedidoAdicionarViewModelProvider).listarProdutoCommand.execute();
    ref
        .read(pedidoAdicionarViewModelProvider)
        .listarFormaPagamentoCommand
        .execute();
    ref
        .read(pedidoAdicionarViewModelProvider)
        .listarCondicaoPagamentoCommand
        .execute();
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
          PedidoAdicionarClienteScreen(
            onPrevious: (cliente) => context.pop(),
            onNext: (cliente) {
              nextStep();
            },
          ),
          PedidoAdicionarProdutoScreen(
            onPrevious: (produto) => prevStep(),
            onNext: (produto) {
              nextStep();
            },
          ),
          PedidoAdicionarPagamentoScreen(
            onPrevious: (pagamento) => prevStep(),
            onNext: (pagamento) {
              nextStep();
            },
          ),
          PedidoAdicionarResumoScreen(
            onPrevious: (resumo) => prevStep(),
            onNext: (resumo) {
              nextStep();
            },
          ),
          PedidoAdicionarSucessoScreen(),
        ],
      ),
    );
  }

  void nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
      _controllers.pageController.nextPage(
        duration: Duration(milliseconds: 1),
        curve: Curves.ease,
      );
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _controllers.pageController.previousPage(
        duration: Duration(milliseconds: 1),
        curve: Curves.ease,
      );
    }
  }
}
