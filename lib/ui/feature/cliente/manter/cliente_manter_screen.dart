import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_view_model.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/contato_endereco/cliente_manter_contato_endereco_screen.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/dados_principais/cliente_manter_dados_principais_screen.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteManterScreen extends BaseScreen {
  final int clienteId;

  const ClienteManterScreen({super.key, required this.clienteId});

  @override
  BaseScreenState<ClienteManterScreen> createState() =>
      _ClienteManterScreenState();
}

class _ClienteManterScreenState extends BaseScreenState<ClienteManterScreen> {
  late final ClienteManterControllers _controllers;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controllers = ClienteManterControllers();

    final viewModel = ref.read(clienteManterViewModelProvider.notifier);
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

    ref.read(clienteManterViewModelProvider).obterPorIdCommand.execute((
      widget.clienteId,
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
          ClienteManterDadosPrincipaisScreen(
            onPrevious: (value) {
              prevStep();
            },
            onNext: (value) {
              nextStep();
            },
          ),
          ClienteManterContatoEnderecoScreen(
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

  void _goToStep(int value) {
    final target = value.clamp(0, 2);
    if (!_controllers.pageController.hasClients) return;

    _controllers.pageController.jumpToPage(target);
    setState(() => currentStep = target);
  }
}

/*
class _ClienteManterScreenState extends BaseScreenState<ClienteManterScreen> {
  late final ClienteManterControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = ClienteManterControllers();

    final viewModel = ref.read(clienteManterViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) {
        return;
      }
      showSnackBar(message, isError: result is Failure);
    };

    ref.read(clienteManterViewModelProvider).obterPorIdCommand.execute((
      widget.clienteId,
    ));
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(clienteManterViewModelProvider);

    ref.listen<ClienteManterUiState>(clienteManterViewModelProvider, (
      previous,
      next,
    ) {
      if (next.cliente != null) {
        _controllers.updateFormFields(next.cliente!);
      }
    });

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: kColorStylePrimary0,
              ),
              child: Form(
                key: _controllers.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTituloBarDefault(
                        title: 'Manter Cliente',
                        onClosePressed: () => Navigator.of(context).pop(),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            buildTextField(_controllers.codigoCliente),
                            buildTextField(
                              _controllers.razaoSocial,
                              isMandatory: true,
                            ),
                            buildTextField(_controllers.nomeFantasia),
                            buildTextField(_controllers.cnpjCpf),
                            buildTextField(_controllers.cidade),
                            buildTextField(_controllers.estado),
                            buildTextField(_controllers.limiteCredito),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: kColorStyleSecondinaryLight200),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButtonSecondary(
                            label: 'Cancelar',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomButtonPrimary(
                            label: 'Salvar',
                            onPressed: () => _handleSalvarPressed(viewModel),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSalvarPressed(ClienteManterUiState viewModel) {
    final isValid = _controllers.formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final request = AtualizarClienteRequest(
      id: widget.clienteId,
      empresaId: viewModel.cliente?.empresaId ?? 0,
      codigoCliente: _controllers.codigoCliente.controller.text.trim(),
      razaoSocial: _controllers.razaoSocial.controller.text.trim(),
      nomeFantasia: _controllers.nomeFantasia.controller.text.trim(),
      cnpjCpf: _controllers.cnpjCpf.controller.text.trim(),
      cidade: _controllers.cidade.controller.text.trim(),
      estado: _controllers.estado.controller.text.trim(),
      limiteCredito: double.tryParse(
        _controllers.limiteCredito.controller.text.trim().replaceAll(',', '.'),
      ),
      vendedorId: viewModel.cliente?.vendedorId,
    );

    ref.read(clienteManterViewModelProvider).atualizarCommand.execute((
      widget.clienteId,
      request,
    ));
  }
}

*/
