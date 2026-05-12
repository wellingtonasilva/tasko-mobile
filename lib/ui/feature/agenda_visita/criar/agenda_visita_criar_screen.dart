import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/domain/dropdown_loading_state.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_textfield_multiline.dart';
import 'package:tasko_mobile/domain/agenda_visita/request/adicionar_agenda_visita_request.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/agenda_visita_criar_controllers.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/agenda_visita_criar_ui_state.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/agenda_visita_criar_view_model.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/widgets/agenda_visita_container_group.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/widgets/agenda_visita_icone_group.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaCriarScreen extends BaseScreen {
  const AgendaVisitaCriarScreen({super.key});

  @override
  BaseScreenState<AgendaVisitaCriarScreen> createState() =>
      _AgendaVisitaCriarScreenState();
}

class _AgendaVisitaCriarScreenState
    extends BaseScreenState<AgendaVisitaCriarScreen> {
  late final AgendaVisitaCriarControllers _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = AgendaVisitaCriarControllers();
    final viewModel = ref.read(agendaVisitaCriarViewModelProvider.notifier);
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
        .read(agendaVisitaCriarViewModelProvider)
        .listarVendedorCommand
        .execute();
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
              child: Form(
                key: _controllers.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTituloBarDefault(title: 'Nova Visita'),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataHoraVisitaGroup(),
                            const SizedBox(height: 16),
                            _buildVendedorGroup(),
                            const SizedBox(height: 16),
                            _buildClienteGroup(),
                            const SizedBox(height: 16),
                            _buildStatusGroup(),
                            const SizedBox(height: 16),
                            _buildDuracaoPrevistaGroup(),
                            const SizedBox(height: 16),
                            _buildObjetivoVisitaGroup(),
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
                            backgroundColor: kColorStyleAgendaVisitaPrimary,
                            label: 'Agendar Visita',
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
    );
  }

  Widget _buildDataHoraVisitaGroup() {
    return AgendaVisitaContainerGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AgendaVisitaIconeGroup(icon: Icons.calendar_month),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      "Data e hora da visita",
                      style: kTestStyleMediumText12.copyWith(
                        color: kColorStyleAgendaVisitaPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              _controllers.dataAgendadaData,
                              showBorder: false,
                              isShowHint: true,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            width: 0.9,
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: buildTextField(
                              _controllers.dataAgendadaHora,
                              showBorder: false,
                              isShowHint: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.access_time,
                              size: 25,
                              color: kColorStyleAgendaVisitaPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVendedorGroup() {
    return AgendaVisitaContainerGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AgendaVisitaIconeGroup(icon: Icons.person_outline),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      "Vendedor",
                      style: kTestStyleMediumText12.copyWith(
                        color: kColorStyleAgendaVisitaPrimary,
                      ),
                    ),
                    _buildLoadingDropdownFieldVendedor(
                      ref.watch(agendaVisitaCriarViewModelProvider),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClienteGroup() {
    return AgendaVisitaContainerGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AgendaVisitaIconeGroup(icon: Icons.business),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      "Cliente",
                      style: kTestStyleMediumText12.copyWith(
                        color: kColorStyleAgendaVisitaPrimary,
                      ),
                    ),
                    _buildLoadingDropdownFieldCliente(
                      ref.watch(agendaVisitaCriarViewModelProvider),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusGroup() {
    return AgendaVisitaContainerGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AgendaVisitaIconeGroup(icon: Icons.flag),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      "Status",
                      style: kTestStyleMediumText12.copyWith(
                        color: kColorStyleAgendaVisitaPrimary,
                      ),
                    ),
                    _buildLoadingDropdownFieldStatus(
                      ref.watch(agendaVisitaCriarViewModelProvider),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDuracaoPrevistaGroup() {
    return AgendaVisitaContainerGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AgendaVisitaIconeGroup(icon: Icons.timer),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Duração Prevista (min)",
                            style: kTestStyleMediumText12.copyWith(
                              color: kColorStyleAgendaVisitaPrimary,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: kColorStyleAgendaVisitaTextSecondary,
                            ),
                            Text(
                              "Tempo estimado",
                              style: kTestStyleRegularText10.copyWith(
                                color: kColorStyleAgendaVisitaTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              _controllers.duracaoPrevista,
                              showBorder: false,
                              isShowHint: true,
                            ),
                          ),
                          Text(
                            "min",
                            style: kTestStyleMediumText12.copyWith(
                              color: kColorStyleAgendaVisitaPrimary,
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildObjetivoVisitaGroup() {
    return AgendaVisitaContainerGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AgendaVisitaIconeGroup(icon: Icons.radar),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      "Objetivo da Visita",
                      style: kTestStyleMediumText12.copyWith(
                        color: kColorStyleAgendaVisitaPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      child: CustomTextfieldMultiline(
                        controller: _controllers.objetivo.controller,
                        hintText: "Descreva o objetivo da visita...",
                        maxLines: 3,
                        minLines: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(color: kColorStyleSecondinaryLight200, thickness: .8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AgendaVisitaIconeGroup(icon: Icons.sticky_note_2),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      "Observações",
                      style: kTestStyleMediumText12.copyWith(
                        color: kColorStyleAgendaVisitaPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      child: CustomTextfieldMultiline(
                        controller: _controllers.observacao.controller,
                        hintText: "Observações adicionais (opcional)...",
                        maxLines: 3,
                        minLines: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -- Vendedor Dropdown
  Widget _buildLoadingDropdownFieldVendedor(
    AgendaVisitaCriarUiState viewModel,
  ) {
    final notifier = ref.read(agendaVisitaCriarViewModelProvider.notifier);
    return switch (notifier.vendedorDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldVendedor(viewModel),
      DropdownLoadingState.error => buildDropdownFieldVendedor(viewModel),
    };
  }

  Widget buildDropdownFieldVendedor(AgendaVisitaCriarUiState viewModel) {
    final notifier = ref.read(agendaVisitaCriarViewModelProvider.notifier);
    final selectedVendedor =
        viewModel.selectedVendedor ?? notifier.computedSelectedVendedor;

    return CustomDropdownButtonFormField<VendedorResponse>(
      edgeInsetsDirectionalStart: -10,
      showBorder: false,
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

  // -- Cliente Dropdown
  Widget _buildLoadingDropdownFieldCliente(AgendaVisitaCriarUiState viewModel) {
    final notifier = ref.read(agendaVisitaCriarViewModelProvider.notifier);
    return switch (notifier.clienteDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldCliente(viewModel),
      DropdownLoadingState.error => buildDropdownFieldCliente(viewModel),
    };
  }

  Widget buildDropdownFieldCliente(AgendaVisitaCriarUiState viewModel) {
    final notifier = ref.read(agendaVisitaCriarViewModelProvider.notifier);
    final selectedCliente =
        viewModel.selectedCliente ?? notifier.computedSelectedCliente;

    return CustomDropdownButtonFormField<ClienteResponse>(
      edgeInsetsDirectionalStart: -10,
      showBorder: false,
      hint: 'Selecione um Cliente',
      items: viewModel.clientes ?? [],
      itemLabelBuilder: (item) => item.razaoSocial ?? '',
      selectedValue: selectedCliente,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Cliente.';
        }
        return null;
      },
      onChanged: (value) {
        notifier.selectCliente(value);
      },
    );
  }

  // -- Status Dropdown
  Widget _buildLoadingDropdownFieldStatus(AgendaVisitaCriarUiState viewModel) {
    final notifier = ref.read(agendaVisitaCriarViewModelProvider.notifier);
    return switch (notifier.statusDropdownState) {
      DropdownLoadingState.loading => buildLoadingIndicator(),
      DropdownLoadingState.ready => buildDropdownFieldStatus(viewModel),
      DropdownLoadingState.error => buildDropdownFieldStatus(viewModel),
    };
  }

  Widget buildDropdownFieldStatus(AgendaVisitaCriarUiState viewModel) {
    final notifier = ref.read(agendaVisitaCriarViewModelProvider.notifier);
    final selectedStatus =
        viewModel.selectedStatus ?? notifier.computedSelectedStatus;

    return CustomDropdownButtonFormField<AgendaVisitaStatusResponse>(
      edgeInsetsDirectionalStart: -10,
      showBorder: false,
      hint: 'Selecione um Status',
      items: viewModel.statusList ?? [],
      itemLabelBuilder: (item) => item.descricaoVisitaStatus ?? '',
      selectedValue: selectedStatus,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecione um Status.';
        }
        return null;
      },
      onChanged: (value) {
        notifier.selectStatus(value);
      },
    );
  }

  void _handleCancelarPressed() {
    Navigator.of(context).pop();
  }

  String? _buildDataAgendadaIso() {
    final data = _controllers.dataAgendadaData.controller.text.trim();
    final hora = _controllers.dataAgendadaHora.controller.text.trim();

    try {
      final parsed = DateFormat('dd/MM/yyyy HH:mm').parseStrict('$data $hora');
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(parsed);
    } catch (_) {
      return null;
    }
  }

  void _handleSalvarPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    final dataAgendada = _buildDataAgendadaIso();
    if (dataAgendada == null) {
      showSnackBar(
        'Informe Data e Hora validas (dd/MM/yyyy e HH:mm).',
        isError: true,
      );
      return;
    }

    ref
        .read(agendaVisitaCriarViewModelProvider)
        .salvarVisitaCommand
        .execute(
          AdicionarAgendaVisitaRequest(
            dataAgendada: dataAgendada,
            duracaoPrevista: int.tryParse(
              _controllers.duracaoPrevista.controller.text,
            ),
            objetivo: _controllers.objetivo.controller.text,
            observacao: _controllers.observacao.controller.text,
          ),
        );
  }
}
