import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart'
    show CustomStepperLine;
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_ui_state.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/cliente_manter_view_model.dart';
import 'package:tasko_mobile/ui/feature/cliente/manter/dados_principais/cliente_manter_dados_principais_controllers.dart';
import 'package:tasko_mobile/util/number_util.dart';

class ClienteManterDadosPrincipaisScreen extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;

  const ClienteManterDadosPrincipaisScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<ClienteManterDadosPrincipaisScreen> createState() =>
      _ClienteManterDadosPrincipaisScreenState();
}

class _ClienteManterDadosPrincipaisScreenState
    extends BaseScreenState<ClienteManterDadosPrincipaisScreen> {
  late final ClienteManterDadosPrincipaisControllers _controllers;
  String _hydratedDraftKey = '';

  @override
  void initState() {
    super.initState();
    _controllers = ClienteManterDadosPrincipaisControllers();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(clienteManterViewModelProvider);
    final draft = viewModel.clienteDraft;
    final draftKey =
        '${draft?.codigoCliente ?? ''}|${draft?.nomeFantasia ?? ''}|${draft?.cnpjCpf ?? ''}';

    if (_hydratedDraftKey != draftKey) {
      _controllers.updateFormFields(draft);
      _hydratedDraftKey = draftKey;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: kColorStylePrimary0,
                ),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(
                          title: 'Manter Cliente',
                          onClosePressed: () => context.pop(false),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _controllers.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomStepperItem(
                                        title: "Dados principais",
                                        active: true,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                      Expanded(
                                        child: CustomStepperLine(
                                          width: double.infinity,
                                        ),
                                      ),
                                      CustomStepperItem(
                                        title: "Contato e Endereço",
                                        active: false,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Dados Básicos',
                                              style: kTestStyleMediumText16
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Preencha as informações principais do cliente.',
                                      style: kTestStyleRegularText12.copyWith(
                                        color: kColorStyleSecondinaryDark400,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    buildTextField(_controllers.codigoCliente),
                                    SizedBox(height: 10),
                                    buildTextField(
                                      _controllers.razaoSocial,
                                      isMandatory: true,
                                    ),
                                    SizedBox(height: 10),
                                    buildTextField(_controllers.nomeFantasia),
                                    SizedBox(height: 10),
                                    buildTextField(_controllers.cnpjCpf),
                                    SizedBox(height: 10),
                                    buildTextField(_controllers.limiteCredito),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Vendedor Responsável',
                                      style: kTestStyleMediumText16.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildLoadingDropdownFieldVendedor(
                                      viewModel,
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Divider(color: kColorStyleSecondinaryLight200),
                      const SizedBox(height: 5),
                      //buildSubmitButton(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomButtonSecondary(
                              label: 'Cancelar',
                              onPressed: () {
                                context.pop(false);
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Próximo',
                              onPressed: () {
                                _onNextPressed();
                              },
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
      ),
    );
  }

  Widget _buildLoadingDropdownFieldVendedor(ClienteManterUiState viewModel) {
    final notifier = ref.read(clienteManterViewModelProvider.notifier);
    return switch (notifier.vendedorDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldVendedor(viewModel),
      DropdownLoadingState.error => buildDropdownFieldVendedor(viewModel),
    };
  }

  Widget buildDropdownFieldVendedor(ClienteManterUiState viewModel) {
    final notifier = ref.read(clienteManterViewModelProvider.notifier);
    final selectedVendedor =
        viewModel.selectedVendedor ?? notifier.computedSelectedVendedor;

    return CustomDropdownButtonFormField<VendedorResponse>(
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(
          Icons.sell,
          color: kColorStyleSecondinaryLight300,
          size: 20,
        ),
      ),
      hint: 'Selecione um Vendedor',
      items: viewModel.vendedores ?? [],
      itemLabelBuilder: (item) => item.nomeVendedor ?? '',
      selectedValue: selectedVendedor,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Vendedor.';
        }
        return null;
      },
      onChanged: (value) {
        notifier.selectVendedor(value);
      },
    );
  }

  void _onNextPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    ref
        .read(clienteManterViewModelProvider.notifier)
        .salvarDadosBasicos(
          codigoCliente: _controllers.codigoCliente.controller.text.trim(),
          razaoSocial: _controllers.razaoSocial.controller.text.trim(),
          nomeFantasia: _controllers.nomeFantasia.controller.text.trim(),
          cnpjCpf: _controllers.cnpjCpf.controller.text.trim(),
          limiteCredito: NumberUtil.parseDouble(
            _controllers.limiteCredito.controller.text.trim(),
          ),
        );

    widget.onNext('Contato e Meta');
  }
}
