import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/cliente_adicionar_controllers.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/cliente_adicionar_view_model.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/dados_principais/cliente_adicionar_dados_principais_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/contato_endereco/cliente_adicionar_contato_endereco_screen.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteAdicionarScreen extends BaseScreen {
  const ClienteAdicionarScreen({super.key});

  @override
  BaseScreenState<ClienteAdicionarScreen> createState() =>
      _ClienteAdicionarScreenState();
}

class _ClienteAdicionarScreenState
    extends BaseScreenState<ClienteAdicionarScreen> {
  late final ClienteAdicionarControllers _controllers;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controllers = ClienteAdicionarControllers();

    final viewModel = ref.read(clienteAdicionarViewModelProvider.notifier);
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
          ClienteAdicionarDadosPrincipaisScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          ClienteAdicionarContatoEnderecoScreen(
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
