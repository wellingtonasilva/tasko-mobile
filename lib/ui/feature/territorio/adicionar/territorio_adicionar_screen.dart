import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/domain/vendedor/request/adicionar_vendedor_territorio_request.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/ui/feature/territorio/adicionar/territorio_adicionar_controllers.dart';
import 'package:tasko_mobile/ui/feature/territorio/adicionar/territorio_adicionar_ui_state.dart';
import 'package:tasko_mobile/ui/feature/territorio/adicionar/territorio_adicionar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class TerritorioAdicionarScreen extends BaseScreen {
  const TerritorioAdicionarScreen({super.key});

  @override
  BaseScreenState<TerritorioAdicionarScreen> createState() =>
      _TerritorioAdicionarScreenState();
}

class _TerritorioAdicionarScreenState
    extends BaseScreenState<TerritorioAdicionarScreen> {
  late final TerritorioAdicionarControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = TerritorioAdicionarControllers();

    final viewModel = ref.read(territorioAdicionarViewModelProvider.notifier);
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

    ref
        .read(territorioAdicionarViewModelProvider)
        .listarSupervisoresCommand
        .execute();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    // Keep the autoDispose provider alive while this screen is mounted.
    ref.watch(territorioAdicionarViewModelProvider);

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
                          title: 'Adicionar Território',
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
                              _buildLoadingDropdownFieldSupervisor(
                                ref.watch(territorioAdicionarViewModelProvider),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: kColorStyleSecondinaryLight200),
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
    TerritorioAdicionarUiState viewModel,
  ) {
    final notifier = ref.read(territorioAdicionarViewModelProvider.notifier);
    return switch (notifier.supervisorDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldSupervisor(viewModel),
      DropdownLoadingState.error => buildDropdownFieldSupervisor(viewModel),
    };
  }

  Widget buildDropdownFieldSupervisor(TerritorioAdicionarUiState viewModel) {
    final notifier = ref.read(territorioAdicionarViewModelProvider.notifier);
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

    final request = AdicionarVendedorTerritorioRequest(
      nomeTerritorio: _controllers.nomeTerritorio.controller.text.trim(),
      descricaoTerritorio: _controllers.descricaoTerritorio.controller.text
          .trim(),
      nomeRegiao: _controllers.nomeRegiao.controller.text.trim(),
      estado: _controllers.estado.controller.text.trim(),
      supervisorId: ref
          .read(territorioAdicionarViewModelProvider.notifier)
          .computedSelectedSupervisor
          ?.id,
    );

    ref
        .read(territorioAdicionarViewModelProvider)
        .adicionarCondicaoPagamentoCommand
        .execute(request);
  }
}
