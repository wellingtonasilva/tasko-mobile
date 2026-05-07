import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/domain/cliente/request/atualizar_cliente_request.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_ui_state.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_view_model.dart';
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomButtonSecondary(
                        label: 'Ver Tabelas de Preco',
                        onPressed: () {
                          context.pushNamed(
                            'clientes-tabelas-preco',
                            pathParameters: {'id': widget.clienteId.toString()},
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            buildTextField(_controllers.codigoCliente),
                            buildTextField(_controllers.razaoSocial),
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
