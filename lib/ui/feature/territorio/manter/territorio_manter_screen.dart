import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/domain/vendedor/request/atualizar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/ui/feature/territorio/manter/territorio_manter_controllers.dart';
import 'package:tasko_mobile/ui/feature/territorio/manter/territorio_manter_ui_state.dart';
import 'package:tasko_mobile/ui/feature/territorio/manter/territorio_manter_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class TerritorioManterScreen extends BaseScreen {
  final int id;

  const TerritorioManterScreen({super.key, required this.id});

  @override
  BaseScreenState<TerritorioManterScreen> createState() =>
      _TerritorioManterScreenState();
}

class _TerritorioManterScreenState
    extends BaseScreenState<TerritorioManterScreen> {
  late final TerritorioManterControllers _controllers;
  int? _lastHydratedTerritorioId;

  @override
  void initState() {
    super.initState();
    _controllers = TerritorioManterControllers();

    final viewModel = ref.read(territorioManterViewModelProvider.notifier);
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

    ref
        .read(territorioManterViewModelProvider)
        .listarSupervisoresCommand
        .execute();

    ref.read(territorioManterViewModelProvider).obterPorIdCommand.execute((
      widget.id,
    ));
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(territorioManterViewModelProvider);
    final territorioAtual = viewModel.territorio;
    if (territorioAtual != null &&
        _lastHydratedTerritorioId != territorioAtual.id) {
      _controllers.updateFormFields(territorioAtual);
      _lastHydratedTerritorioId = territorioAtual.id;
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
                  key: _controllers.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(
                          title: 'Manter Território',
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
                              SizedBox(height: 10),
                              buildTextField(
                                _controllers.nomeTerritorio,
                                isMandatory: true,
                              ),
                              SizedBox(height: 10),
                              buildTextField(
                                _controllers.descricaoTerritorio,
                                isMandatory: false,
                              ),
                              SizedBox(height: 10),
                              buildTextField(
                                _controllers.nomeRegiao,
                                isMandatory: false,
                              ),
                              SizedBox(height: 10),
                              buildTextField(
                                _controllers.estado,
                                isMandatory: false,
                              ),
                              const SizedBox(height: 15),
                              const Text('Supervisor'),
                              const SizedBox(height: 10),
                              _buildLoadingDropdownFieldSupervisor(viewModel),
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

  Widget _buildLoadingDropdownFieldSupervisor(
    TerritorioManterUiState viewModel,
  ) {
    final notifier = ref.read(territorioManterViewModelProvider.notifier);
    return switch (notifier.supervisorDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldSupervisor(viewModel),
      DropdownLoadingState.error => buildDropdownFieldSupervisor(viewModel),
    };
  }

  Widget buildDropdownFieldSupervisor(TerritorioManterUiState viewModel) {
    final notifier = ref.read(territorioManterViewModelProvider.notifier);
    final selectedSupervisor =
        notifier.computedSelectedSupervisor ?? viewModel.selectedSupervisor;

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
      items: viewModel.supervisores,
      itemLabelBuilder: (item) => item.nomeSupervisor ?? '',
      selectedValue: selectedSupervisor,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Supervisor.';
        }
        return null;
      },
      onChanged: (value) {
        notifier.selecionarSupervisor(value);
      },
    );
  }

  void _handleCancelarPressed() {
    Navigator.of(context).pop(false);
  }

  void _handleSalvarPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    final request = AtualizarVendedorTerritorioRequest(
      nomeTerritorio: _controllers.nomeTerritorio.controller.text.trim(),
      descricaoTerritorio: _controllers.descricaoTerritorio.controller.text
          .trim(),
      nomeRegiao: _controllers.nomeRegiao.controller.text.trim(),
      estado: _controllers.estado.controller.text.trim(),
      supervisorId: ref
          .read(territorioManterViewModelProvider.notifier)
          .computedSelectedSupervisor
          ?.id,
      id: widget.id,
    );

    ref.read(territorioManterViewModelProvider).atualizarCommand.execute((
      request.id,
      request,
    ));
  }
}
