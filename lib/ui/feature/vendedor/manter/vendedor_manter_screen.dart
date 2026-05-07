import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/dados_basicos/vendedor_manter_dados_basicos_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/meta/vendedor_manter_meta_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/resumo/vendedor_manter_dados_resumo.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorManterScreen extends BaseScreen {
  final int vendedorId;

  const VendedorManterScreen({super.key, required this.vendedorId});

  @override
  BaseScreenState<VendedorManterScreen> createState() =>
      _VendedorManterScreenState();
}

class _VendedorManterScreenState extends BaseScreenState<VendedorManterScreen> {
  late final VendedorManterControllers _controllers;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();

    _controllers = VendedorManterControllers();

    final viewModel = ref.read(vendedorManterViewModelProvider.notifier);
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

    ref.read(vendedorManterViewModelProvider).obterPorIdCommand.execute((
      widget.vendedorId,
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
          VendedorManterDadosBasicosScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          VendedorManterMetaScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          VendedorManterDadosResumo(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              // Handle final submission or navigation
            },
            gotoStep: (value) {
              _goToStep(value);
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

  void _goToStep(int value) {
    final target = value.clamp(0, 2);
    if (!_controllers.pageController.hasClients) return;

    _controllers.pageController.jumpToPage(target);
    setState(() => currentStep = target);
  }
}
