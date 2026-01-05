import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_app_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_icon_button.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_form_field_data.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_label.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_textfield.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
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
  final formKey = GlobalKey<FormState>();
  // Form Fields
  late final CustomFormFieldData id;
  late final CustomFormFieldData codigoVendedor;
  late final CustomFormFieldData nomeVendedor;
  late final CustomFormFieldData numeroCPF;
  late final CustomFormFieldData email;
  late final CustomFormFieldData numeroTelefone;
  late final CustomFormFieldData valorMetaMensal;
  late final CustomFormFieldData percentualComissao;
  late final CustomFormFieldData ultimoSincronismo;
  late final CustomFormFieldData codigoDispositivo;

  /*
 final String codigoVendedor;
  final String ;
  final String ;
  final String ;
  final String ;
  final double? ;
  final double ;
  final DateTime? ;
  final String? ;
  final VendedorSupervisorResponse? supervisor;
  final VendedorTerritorioResponse? territorio;
  final Auditoria? auditoria;
  */

  @override
  initState() {
    super.initState();

    id = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'ID',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o ID.' : null,
    );
    codigoVendedor = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Código Vendedor',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Código Vendedor.'
          : null,
    );
    nomeVendedor = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Nome Vendedor',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Nome Vendedor.'
          : null,
    );
    numeroCPF = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Número CPF',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Número CPF.' : null,
    );
    email = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Email',
      validator: (context, val) =>
          val == null || val.isEmpty ? 'Por favor informe o Email.' : null,
    );
    numeroTelefone = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Número Telefone',
      validator: (context, val) => val == null || val.isEmpty
          ? 'Por favor informe o Número Telefone.'
          : null,
    );
    valorMetaMensal = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Valor Meta Mensal',
    );
    percentualComissao = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Percentual Comissão',
    );
    ultimoSincronismo = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Último Sincronismo',
    );
    codigoDispositivo = CustomFormFieldData(
      controller: TextEditingController(),
      focusNode: FocusNode(),
      labelText: 'Código Dispositivo',
    );

    ref.read(vendedorManterViewModelProvider).obterPorIdCommand.execute((
      widget.vendedorId,
    ));

    final viewModel = ref.read(vendedorManterViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: kColorStyleSuccessDarkDefault,
            ),
          );
        } else if (result is Failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      }
    };
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
        updateFormFields(next.vendedor!);
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
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Manter Vendedor',
                              style: kTestStyleBoldText20.copyWith(
                                color: kColorStyleSecondinaryDarkDefault,
                              ),
                            ),
                            CustomIconButton(
                              icon: const Icon(
                                Icons.close,
                                color: kColorStyleSecondinaryDarkDefault,
                                size: 20,
                              ),
                              borderRadius: 5,
                              buttonSize: 35,
                              fillColor: Colors.white,
                              hoverColor: Colors.grey.shade200,
                              borderColor: kColorStyleSecondinaryLight200,
                              borderWidth: 1,
                              showLoadingIndicator: false,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextField(codigoVendedor),
                              buildTextField(nomeVendedor),
                              buildTextField(numeroCPF),
                              buildTextField(email),
                              buildTextField(numeroTelefone),
                              buildTextField(valorMetaMensal),
                              buildTextField(percentualComissao),
                              buildTextField(
                                ultimoSincronismo,
                                isReadOnly: true,
                              ),
                              buildTextField(
                                codigoDispositivo,
                                isReadOnly: true,
                              ),
                              const SizedBox(height: 10),
                              const Text('Supervisor'),
                              const SizedBox(height: 10),
                              viewModel.listarSupervisorCommand.running
                                  ? buildLoadingIndicator()
                                  : viewModel.obterPorIdCommand.completed &&
                                        viewModel
                                            .listarSupervisorCommand
                                            .completed
                                  ? buildDropdownFieldSupervisor(viewModel)
                                  : buildLoadingIndicator(),
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
                                formKey.currentState?.reset();
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Salvar',
                              onPressed: () {},
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
          CustomTextfield(controller: field.controller),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 50.0,
        height: 50.0,
        child: CircularProgressIndicator(
          color: kColorStylePrimaryNeutralPaletteDarkDefault,
        ),
      ),
    );
  }

  Widget buildDropdownFieldSupervisor(VendedorManterUiState viewModel) {
    viewModel.selectedSupervisor = viewModel.supervisores?.firstWhere(
      (element) => element.id == viewModel.vendedor?.supervisor?.id,
      orElse: () => VendedorSupervisorResponse(
        id: -1,
        nomeSupervisor: 'Default',
        auditoria: null,
      ),
    );

    if (viewModel.selectedSupervisor?.id == -1) {
      viewModel.selectedSupervisor = null;
    }

    return CustomDropdownButtonFormField<VendedorSupervisorResponse>(
      hint: 'Selecione um Supervisor',
      items: viewModel.supervisores ?? [],
      itemLabelBuilder: (item) => item.nomeSupervisor,
      selectedValue: viewModel.selectedSupervisor,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Responsável.';
        }
        return null;
      },
      onChanged: (value) {
        viewModel.selectedSupervisor = value;
      },
      onSaved: (value) {
        viewModel.selectedSupervisor = value;
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

  void updateFormFields(VendedorResponse vendedor) {
    id.controller.text = vendedor.id.toString();
    codigoVendedor.controller.text = vendedor.codigoVendedor;
    nomeVendedor.controller.text = vendedor.nomeVendedor;
    numeroCPF.controller.text = vendedor.numeroCPF;
    email.controller.text = vendedor.email;
    numeroTelefone.controller.text = vendedor.numeroTelefone;
    valorMetaMensal.controller.text =
        vendedor.valorMetaMensal?.toStringAsFixed(2) ?? '';
    percentualComissao.controller.text = vendedor.percentualComissao
        .toStringAsFixed(2);
    ultimoSincronismo.controller.text =
        vendedor.ultimoSincronismo?.toIso8601String() ?? '';
    codigoDispositivo.controller.text = vendedor.codigoDispositivo ?? '';
  }
}
