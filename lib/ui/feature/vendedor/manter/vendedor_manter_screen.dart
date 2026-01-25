import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_app_bar_default.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_label.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_textfield.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_ui_state.dart';
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

  @override
  initState() {
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

    ref.read(vendedorManterViewModelProvider).obterPorIdCommand.execute((
      widget.vendedorId,
    ));
  }

  @override
  dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBarDefault(
      onMenuPressed: () {
        showSnackBar('Menu pressed', isError: false);
      },
      onSearchPressed: () {
        showSnackBar('Search pressed', isError: false);
      },
      onSettingsPressed: () {
        showSnackBar('Settings pressed', isError: false);
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(vendedorManterViewModelProvider);
    ref.listen<VendedorManterUiState>(vendedorManterViewModelProvider, (
      previous,
      next,
    ) {
      if (next.vendedor != null) {
        _controllers.updateFormFields(next.vendedor!);
        setState(() {});
      }
    });

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
                  key: _controllers.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(
                          title: 'Manter Vendedor',
                          onClosePressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextField(_controllers.codigoVendedor),
                              buildTextField(_controllers.nomeVendedor),
                              buildTextField(_controllers.numeroCPF),
                              buildTextField(_controllers.email),
                              buildTextField(_controllers.numeroTelefone),
                              buildTextField(_controllers.valorMetaMensal),
                              buildTextField(_controllers.percentualComissao),
                              buildTextField(
                                _controllers.ultimoSincronismo,
                                isReadOnly: true,
                              ),
                              buildTextField(
                                _controllers.codigoDispositivo,
                                isReadOnly: true,
                              ),
                              const SizedBox(height: 10),
                              const Text('Supervisor'),
                              const SizedBox(height: 10),
                              _buildLoadingDropdownFieldSupervisor(viewModel),
                              const SizedBox(height: 10),
                              const Text('Território'),
                              const SizedBox(height: 10),
                              viewModel.listarTerritorioCommand.running
                                  ? buildLoadingIndicator()
                                  : viewModel.obterPorIdCommand.completed &&
                                        viewModel
                                            .listarTerritorioCommand
                                            .completed
                                  ? buildDropdownFieldTerritorio(viewModel)
                                  : buildLoadingIndicator(),
                              const SizedBox(height: 20),
                            ],
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
                                _handleCancelarPressed();
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Salvar',
                              onPressed: () {
                                _handleSalvarPressed();
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

  Widget buildTextField(
    CustomFormFieldData field, {
    bool isDate = false,
    bool isReadOnly = false,
  }) {
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

  Widget _buildLoadingDropdownFieldSupervisor(VendedorManterUiState viewModel) {
    return switch (ref
        .read(vendedorManterViewModelProvider.notifier)
        .supervisorDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldSupervisor(viewModel),
      DropdownLoadingState.error => buildDropdownFieldSupervisor(viewModel),
    };
  }

  Widget buildDropdownFieldSupervisor(VendedorManterUiState viewModel) {
    return CustomDropdownButtonFormField<VendedorSupervisorResponse>(
      hint: 'Selecione um Supervisor',
      items: viewModel.supervisores ?? [],
      itemLabelBuilder: (item) => item.nomeSupervisor ?? '',
      selectedValue:
          viewModel.selectedSupervisor ??
          ref
              .read(vendedorManterViewModelProvider.notifier)
              .computedSelectedSupervisor,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Responsável.';
        }
        return null;
      },
      onChanged: (value) {
        ref
            .read(vendedorManterViewModelProvider.notifier)
            .selectSupervisor(value);
      },
      onSaved: (value) {
        ref
            .read(vendedorManterViewModelProvider.notifier)
            .selectSupervisor(value);
      },
    );
  }

  Widget buildDropdownFieldTerritorio(VendedorManterUiState viewModel) {
    viewModel.selectedTerritorio = viewModel.territorios?.firstWhere(
      (element) => element.id == viewModel.vendedor?.territorio?.id,
      orElse: () =>
          VendedorTerritorioResponse(id: -1, nomeTerritorio: 'Default'),
    );

    if (viewModel.selectedTerritorio?.id == -1) {
      viewModel.selectedTerritorio = null;
    }

    return CustomDropdownButtonFormField<VendedorTerritorioResponse>(
      hint: 'Selecione um Território',
      items: viewModel.territorios ?? [],
      itemLabelBuilder: (item) => item.nomeTerritorio,
      selectedValue: viewModel.selectedTerritorio,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Território.';
        }
        return null;
      },
      onChanged: (value) {
        viewModel.selectedTerritorio = value;
      },
      onSaved: (value) {
        viewModel.selectedTerritorio = value;
      },
    );
  }

  void _handleCancelarPressed() {
    showSnackBar('Cancelar pressed');
  }

  void _handleSalvarPressed() {
    if (_controllers.formKey.currentState?.validate() ?? false) {
      _controllers.formKey.currentState?.save();

      final viewModel = ref.read(vendedorManterViewModelProvider);

      final request = AtualizarVendedorRequest(
        id: int.tryParse(_controllers.id.controller.text) ?? 0,
        codigoVendedor: _controllers.codigoVendedor.controller.text,
        nomeVendedor: _controllers.nomeVendedor.controller.text,
        numeroCPF: _controllers.numeroCPF.controller.text,
        email: _controllers.email.controller.text,
        numeroTelefone: _controllers.numeroTelefone.controller.text,
        valorMetaMensal:
            double.tryParse(_controllers.valorMetaMensal.controller.text) ??
            0.0,
        percentualComissao:
            double.tryParse(_controllers.percentualComissao.controller.text) ??
            0.0,
        supervisorId: viewModel.selectedSupervisor?.id ?? 0,
        territorioId: viewModel.selectedTerritorio?.id ?? 0,
      );

      ref.read(vendedorManterViewModelProvider).atualizarCommand.execute((
        widget.vendedorId,
        request,
      ));
    }
  }
}
