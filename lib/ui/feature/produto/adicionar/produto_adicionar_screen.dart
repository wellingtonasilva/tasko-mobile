import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/adicionar/dados_basicos/produto_adicionar_dados_basicos_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/adicionar/precos_margem/produto_adicionar_pecos_margens_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/adicionar/produto_adicionar_controllers.dart';
import 'package:tasko_mobile/ui/feature/produto/adicionar/produto_adicionar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoAdicionarScreen extends BaseScreen {
  const ProdutoAdicionarScreen({super.key});

  @override
  BaseScreenState<ProdutoAdicionarScreen> createState() =>
      _ProdutoAdicionarScreenState();
}

class _ProdutoAdicionarScreenState
    extends BaseScreenState<ProdutoAdicionarScreen> {
  late final ProdutoAdicionarControllers _controllers;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controllers = ProdutoAdicionarControllers();

    final viewModel = ref.read(produtoAdicionarViewModelProvider.notifier);
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

    ref
        .read(produtoAdicionarViewModelProvider)
        .listarUnidadeMedidaCommand
        .execute();
    ref.read(produtoAdicionarViewModelProvider).listarGrupoCommand.execute();
    ref.read(produtoAdicionarViewModelProvider).listarSubgrupoCommand.execute();
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
          ProdutoAdicionarDadosBasicosScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          ProdutoAdicionarPecosMargensScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
        ],
      ),
    );
  }

  void nextStep() {
    if (currentStep < 2) {
      setState(() => currentStep++);
      _controllers.pageController.nextPage(
        duration: Duration(milliseconds: 5),
        curve: Curves.ease,
      );
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _controllers.pageController.previousPage(
        duration: Duration(milliseconds: 5),
        curve: Curves.ease,
      );
    }
  }
}
