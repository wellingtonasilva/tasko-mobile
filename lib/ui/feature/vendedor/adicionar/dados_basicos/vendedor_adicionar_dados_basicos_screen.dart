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
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_label.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/dados_basicos/vendedor_adicionar_dados_basicos_controllers.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/vendedor_adicionar_ui_state.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/vendedor_adicionar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorAdicionarDadosBasicosScreen extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;

  const VendedorAdicionarDadosBasicosScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<VendedorAdicionarDadosBasicosScreen> createState() =>
      _VendedorAdicionarDadosBasicosScreenState();
}

class _VendedorAdicionarDadosBasicosScreenState
    extends BaseScreenState<VendedorAdicionarDadosBasicosScreen> {
  late final VendedorAdicionarDadosBasicosControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = VendedorAdicionarDadosBasicosControllers();

    final viewModel = ref.read(vendedorAdicionarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(vendedorAdicionarViewModelProvider);

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
                          title: 'Adicionar Vendedor',
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
                                        title: "Dados Básicos",
                                        active: true,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                      Expanded(
                                        child: CustomStepperLine(
                                          width: double.infinity,
                                        ),
                                      ),
                                      CustomStepperItem(
                                        title: "Contato e Meta",
                                        active: false,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                      Expanded(
                                        child: CustomStepperLine(
                                          width: double.infinity,
                                        ),
                                      ),
                                      CustomStepperItem(
                                        title: "Revisão",
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
                                            Center(
                                              child: Icon(
                                                Icons.person_outline,
                                                color:
                                                    kColorStylePrimaryNeutralPaletteDarkDefault,
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(width: 5),
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
                                      'Preencha as informações principais do vendedor.',
                                      style: kTestStyleRegularText12.copyWith(
                                        color: kColorStyleSecondinaryDark400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.codigoVendedor,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.nomeVendedor,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.numeroCPF,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 20),
                                CustomLabel(
                                  labelText: 'Status',
                                  mandatory: true,
                                ),
                                _buildDropdownStatus(),
                                const SizedBox(height: 10),
                                const Text('Supervisor'),
                                const SizedBox(height: 10),
                                _buildLoadingDropdownFieldSupervisor(viewModel),
                                const SizedBox(height: 15),
                                const Text('Território'),
                                const SizedBox(height: 5),
                                _buildLoadingDropdownFieldTerritorio(viewModel),
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
                              onPressed: _onNextPressed,
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

  void _onNextPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    final indicadorAtivo =
        (ref
            .read(vendedorAdicionarViewModelProvider)
            .vendedorDraft
            ?.auditoria
            ?.indicadorAtivo) ??
        true;

    ref
        .read(vendedorAdicionarViewModelProvider.notifier)
        .salvarDadosBasicos(
          codigoVendedor: _controllers.codigoVendedor.controller.text.trim(),
          nomeVendedor: _controllers.nomeVendedor.controller.text.trim(),
          numeroCPF: _controllers.numeroCPF.controller.text.trim(),
          indicadorAtivo: indicadorAtivo,
        );

    widget.onNext('Contato e Meta');
  }

  Widget _buildDropdownStatus() {
    final viewState = ref.watch(vendedorAdicionarViewModelProvider);
    final indicadorAtivo = viewState.vendedorDraft?.auditoria?.indicadorAtivo;
    final selectedStatus = indicadorAtivo == null
        ? null
        : (indicadorAtivo ? 'Ativo' : 'Inativo');
    const status = ['Ativo', 'Inativo'];

    return CustomDropdownButtonFormField<String>(
      hint: 'Selecione o Status',
      items: status,
      itemLabelBuilder: (item) => item,
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(
          Icons.flag,
          color: kColorStyleSecondinaryLight300,
          size: 20,
        ),
      ),
      selectedValue: selectedStatus,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Status.';
        }
        return null;
      },
      onChanged: (value) {
        ref
            .read(vendedorAdicionarViewModelProvider.notifier)
            .setIndicadorAtivo(value == 'Ativo');
      },
    );
  }

  Widget _buildLoadingDropdownFieldSupervisor(
    VendedorAdicionarUiState viewModel,
  ) {
    final notifier = ref.read(vendedorAdicionarViewModelProvider.notifier);
    return switch (notifier.supervisorDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldSupervisor(viewModel),
      DropdownLoadingState.error => buildDropdownFieldSupervisor(viewModel),
    };
  }

  Widget buildDropdownFieldSupervisor(VendedorAdicionarUiState viewModel) {
    final notifier = ref.read(vendedorAdicionarViewModelProvider.notifier);
    final selectedSupervisor =
        viewModel.selectedSupervisor ?? notifier.computedSelectedSupervisor;

    return CustomDropdownButtonFormField<VendedorSupervisorResponse>(
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(
          Icons.supervisor_account,
          color: kColorStyleSecondinaryLight300,
          size: 20,
        ),
      ),
      hint: 'Selecione um Supervisor',
      items: viewModel.supervisores ?? [],
      itemLabelBuilder: (item) => item.nomeSupervisor ?? '',
      selectedValue: selectedSupervisor,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Responsável.';
        }
        return null;
      },
      onChanged: (value) {
        notifier.selectSupervisor(value);
      },
    );
  }

  Widget buildDropdownFieldTerritorio(VendedorAdicionarUiState viewModel) {
    final notifier = ref.read(vendedorAdicionarViewModelProvider.notifier);
    final selectedTerritorio =
        viewModel.selectedTerritorio ?? notifier.computedSelectedTerritorio;

    return CustomDropdownButtonFormField<VendedorTerritorioResponse>(
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        child: Icon(Icons.map, color: kColorStyleSecondinaryLight300, size: 20),
      ),
      hint: 'Selecione um Território',
      items: viewModel.territorios ?? [],
      itemLabelBuilder: (item) => item.nomeTerritorio ?? '',
      selectedValue: selectedTerritorio,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Território.';
        }
        return null;
      },
      onChanged: (value) {
        notifier.selectTerritorio(value);
      },
    );
  }

  Widget _buildLoadingDropdownFieldTerritorio(
    VendedorAdicionarUiState viewModel,
  ) {
    final notifier = ref.read(vendedorAdicionarViewModelProvider.notifier);
    return switch (notifier.territorioDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldTerritorio(viewModel),
      DropdownLoadingState.error => buildDropdownFieldTerritorio(viewModel),
    };
  }
}
