import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_textfield_medium.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_textfield_multiline.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_status_response.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/criar/agenda_visita_criar_controllers.dart';
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "20/08/2024",
                                style: kTestStyleMediumText16.copyWith(
                                  color: kColorStyleAgendaVisitaTextPrimary,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              width: 0.9,
                              height: 20,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "19:30",
                                style: kTestStyleMediumText16.copyWith(
                                  color: kColorStyleAgendaVisitaTextPrimary,
                                ),
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
                    const SizedBox(height: 8),
                    Text(
                      "Vendedor 1",
                      style: kTestStyleMediumText16.copyWith(
                        color: kColorStyleAgendaVisitaTextPrimary,
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
                    const SizedBox(height: 8),
                    Text(
                      "Cliente 1",
                      style: kTestStyleMediumText16.copyWith(
                        color: kColorStyleAgendaVisitaTextPrimary,
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
                    const SizedBox(height: 8),
                    Text(
                      "Pendente",
                      style: kTestStyleMediumText16.copyWith(
                        color: kColorStyleAgendaVisitaTextPrimary,
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
                    Text(
                      "Duração Prevista",
                      style: kTestStyleMediumText12.copyWith(
                        color: kColorStyleAgendaVisitaPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "30 minutos",
                      style: kTestStyleMediumText16.copyWith(
                        color: kColorStyleAgendaVisitaTextPrimary,
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
        Divider(color: kColorStyleSecondinaryLight200),
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

  void _handleCancelarPressed() {
    Navigator.of(context).pop();
  }

  void _handleSalvarPressed() {}
}

/*
class _AgendaVisitaCriarScreenState
    extends BaseScreenState<AgendaVisitaCriarScreen> {
  late final AgendaVisitaCriarControllers _controllers;

  final _formKey = GlobalKey<FormState>();
  final _objetivoController = TextEditingController();
  final _observacaoController = TextEditingController();
  final _duracaoController = TextEditingController();

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = AgendaVisitaCriarControllers();

    final viewModel = ref.read(agendaVisitaCriarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) return;
      if (result is Success) {
        showSnackBar(message, isError: false);
      } else {
        showSnackBar(message, isError: true);
      }
    };
    viewModel.onSalvarSucesso = () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    };
  }

  @override
  void dispose() {
    _objetivoController.dispose();
    _observacaoController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(agendaVisitaCriarViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomTituloBarDefault(title: 'Agendar Visita'),
                const SizedBox(height: 24),

                // Data agendada
                Text('Data da Visita', style: kTestStyleBoldText16),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: viewModel.dataAgendada,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null && mounted) {
                      final withTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          viewModel.dataAgendada,
                        ),
                      );
                      final dateTime = withTime != null
                          ? DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              withTime.hour,
                              withTime.minute,
                            )
                          : picked;
                      ref
                          .read(agendaVisitaCriarViewModelProvider.notifier)
                          .selecionarData(dateTime);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '${_formatDate(viewModel.dataAgendada)} ${viewModel.dataAgendada.hour.toString().padLeft(2, '0')}:${viewModel.dataAgendada.minute.toString().padLeft(2, '0')}',
                      style: kTestStyleMediumText16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Vendedor
                Text('Vendedor', style: kTestStyleBoldText16),
                const SizedBox(height: 8),
                viewModel.carregarDadosCommand.running
                    ? const Center(child: CircularProgressIndicator())
                    : CustomDropdownButtonFormField<VendedorResponse>(
                        hint: 'Selecione um vendedor',
                        items: viewModel.vendedores,
                        itemLabelBuilder: (v) => v.nomeVendedor ?? '-',
                        selectedValue: viewModel.vendedorSelecionado,
                        onChanged: (v) {
                          ref
                              .read(agendaVisitaCriarViewModelProvider.notifier)
                              .selecionarVendedor(v);
                        },
                      ),
                const SizedBox(height: 16),
                // Cliente
                Text('Cliente', style: kTestStyleBoldText16),
                const SizedBox(height: 8),
                viewModel.carregarDadosCommand.running
                    ? const Center(child: CircularProgressIndicator())
                    : CustomDropdownButtonFormField<ClienteResponse>(
                        hint: 'Selecione um cliente',
                        items: viewModel.clientes,
                        itemLabelBuilder: (c) =>
                            c.nomeFantasia ?? c.razaoSocial,
                        selectedValue: viewModel.clienteSelecionado,
                        onChanged: (c) {
                          ref
                              .read(agendaVisitaCriarViewModelProvider.notifier)
                              .selecionarCliente(c);
                        },
                      ),
                const SizedBox(height: 16),

                // Status
                Text('Status', style: kTestStyleBoldText16),
                const SizedBox(height: 8),
                CustomDropdownButtonFormField<AgendaVisitaStatusResponse>(
                  hint: 'Selecione o status',
                  items: viewModel.statusList,
                  itemLabelBuilder: (s) => s.descricaoVisitaStatus ?? '-',
                  selectedValue: viewModel.statusSelecionado,
                  onChanged: (s) {
                    ref
                        .read(agendaVisitaCriarViewModelProvider.notifier)
                        .selecionarStatus(s);
                  },
                ),
                const SizedBox(height: 16),

                // Duração prevista
                Text('Duração Prevista (min)', style: kTestStyleBoldText16),
                const SizedBox(height: 8),
                CustomTextfieldMedium(
                  labelText: 'Duração em minutos',
                  controller: _duracaoController,
                ),
                const SizedBox(height: 16),

                // Objetivo
                Text('Objetivo', style: kTestStyleBoldText16),
                const SizedBox(height: 8),
                CustomTextfieldMedium(
                  labelText: 'Objetivo da visita',
                  controller: _objetivoController,
                ),
                const SizedBox(height: 16),

                // Observação
                Text('Observação', style: kTestStyleBoldText16),
                const SizedBox(height: 8),
                CustomTextfieldMedium(
                  labelText: 'Observações adicionais',
                  controller: _observacaoController,
                ),
                const SizedBox(height: 32),

                // Botão Salvar
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonPrimary(
                    label: viewModel.salvarVisitaCommand.running
                        ? 'Salvando...'
                        : 'Agendar Visita',
                    onPressed: viewModel.salvarVisitaCommand.running
                        ? () {}
                        : () {
                            final notifier = ref.read(
                              agendaVisitaCriarViewModelProvider.notifier,
                            );
                            notifier.atualizarObjetivo(
                              _objetivoController.text,
                            );
                            notifier.atualizarObservacao(
                              _observacaoController.text,
                            );
                            final duracao = int.tryParse(
                              _duracaoController.text,
                            );
                            notifier.atualizarDuracao(duracao);

                            viewModel.salvarVisitaCommand.execute(null);
                          },
                    trailingIcon: Icons.check,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

*/
