import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/metas/comissao/vendedor_metas_comissao_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/metas/financeiro/vendedor_metas_financeiro_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/metas/pedidos_clientes/vendedor_metas_pedidos_clienes_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/metas/resumo/vendedor_metas_resumo_screen.dart';
import 'package:tasko_mobile/ui/feature/vendedor/metas/vendedor_metas_controllers.dart';

class VendedorMetasScreen extends BaseScreen {
  final int vendedorId;

  const VendedorMetasScreen({super.key, required this.vendedorId});

  @override
  BaseScreenState<VendedorMetasScreen> createState() =>
      _VendedorMetasScreenState();
}

class _VendedorMetasScreenState extends BaseScreenState<VendedorMetasScreen> {
  late final VendedorMetasControllers _controllers;
  late final int vendedorId;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();

    _controllers = VendedorMetasControllers();
    vendedorId = widget.vendedorId;
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
          VendedorMetasResumoScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          VendedorMetasFinanceiroScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          VendedorMetasPedidosClienesScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          VendedorMetasComissaoScreen(
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
