import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_label.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_textfield.dart';
import 'package:tasko_mobile/domain/cliente/request/adicionar_cliente_request.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/cliente_adicionar_controllers.dart';
import 'package:tasko_mobile/ui/feature/cliente/adicionar/cliente_adicionar_view_model.dart';
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

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = ClienteAdicionarControllers();

    final viewModel = ref.read(clienteAdicionarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) {
        return;
      }
      showSnackBar(message, isError: result is Failure);
    };

    viewModel.onAdicionarSucesso = () {
      if (mounted) {
        Navigator.of(context).pop(true);
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
                        title: 'Adicionar Cliente',
                        onClosePressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            _buildTextField(_controllers.codigoCliente),
                            _buildTextField(_controllers.razaoSocial),
                            _buildTextField(_controllers.nomeFantasia),
                            _buildTextField(_controllers.cnpjCpf),
                            _buildTextField(_controllers.cidade),
                            _buildTextField(_controllers.estado),
                            _buildTextField(_controllers.limiteCredito),
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
                            onPressed: _handleSalvarPressed,
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

  Widget _buildTextField(CustomFormFieldData field) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          CustomLabel(labelText: field.labelText),
          const SizedBox(height: 10),
          CustomTextfield(
            controller: field.controller,
            validator: field.validator,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _handleSalvarPressed() {
    final isValid = _controllers.formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final request = AdicionarClienteRequest(
      codigoCliente: _controllers.codigoCliente.controller.text.trim(),
      razaoSocial: _controllers.razaoSocial.controller.text.trim(),
      nomeFantasia: _controllers.nomeFantasia.controller.text.trim(),
      cnpjCpf: _controllers.cnpjCpf.controller.text.trim(),
      cidade: _controllers.cidade.controller.text.trim(),
      estado: _controllers.estado.controller.text.trim(),
      limiteCredito: double.tryParse(
        _controllers.limiteCredito.controller.text.trim().replaceAll(',', '.'),
      ),
    );

    ref
        .read(clienteAdicionarViewModelProvider)
        .adicionarCommand
        .execute(request);
  }
}
