import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/dados_basicos/produto_manter_dados_basicos_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/precos_margem/produto_manter_precos_margem_screen.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/produto_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/produto/manter/produto_manter_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoManterScreen extends BaseScreen {
  const ProdutoManterScreen({super.key, required this.produtoId});

  final int produtoId;

  @override
  BaseScreenState<ProdutoManterScreen> createState() =>
      _ProdutoManterScreenState();
}

class _ProdutoManterScreenState extends BaseScreenState<ProdutoManterScreen> {
  late final ProdutoManterControllers _controllers;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();

    _controllers = ProdutoManterControllers();

    final viewModel = ref.read(produtoManterViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };

    viewModel.onManterSucesso = () {
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

    ref.read(produtoManterViewModelProvider).obterPorIdCommand.execute((
      widget.produtoId,
    ));
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
          ProdutoManterDadosBasicosScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          ProdutoManterPrecosMargemScreen(
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
