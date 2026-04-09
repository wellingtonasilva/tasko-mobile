import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_textfield_medium.dart';

import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_checkin_response.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/checkins_tipo_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/detalhe/agenda_visita_detalhe_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class AgendaVisitaDetalheScreen extends BaseScreen {
  final int agendaVisitaId;

  const AgendaVisitaDetalheScreen({super.key, required this.agendaVisitaId});

  @override
  BaseScreenState<AgendaVisitaDetalheScreen> createState() =>
      _AgendaVisitaDetalheScreenState();
}

class _AgendaVisitaDetalheScreenState
    extends BaseScreenState<AgendaVisitaDetalheScreen> {
  bool _initialized = false;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(agendaVisitaDetalheViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) return;
      if (result is Success) {
        showSnackBar(message, isError: false);
      } else {
        showSnackBar(message, isError: true);
      }
    };
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(agendaVisitaDetalheViewModelProvider);

    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(agendaVisitaDetalheViewModelProvider.notifier)
            .init(widget.agendaVisitaId);
      });
    }

    if (viewModel.carregarDadosCommand.running) {
      return const Center(child: CircularProgressIndicator());
    }

    final visita = viewModel.visita;
    if (visita == null) {
      return const Center(child: Text('Visita não encontrada.'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTituloBarDefault(title: 'Detalhes da Visita'),
            const SizedBox(height: 24),

            // Informações da visita
            _SectionCard(
              title: 'Informações',
              children: [
                _InfoRow(
                  label: 'Status',
                  value: visita.agendaVisitaStatusNome ?? '-',
                ),
                _InfoRow(
                  label: 'Data Agendada',
                  value: _formatDateTime(visita.dataAgendada),
                ),
                if (visita.dataRealizada != null)
                  _InfoRow(
                    label: 'Data Realizada',
                    value: _formatDateTime(visita.dataRealizada!),
                  ),
                _InfoRow(
                  label: 'Duração Prevista',
                  value: visita.duracaoPrevista != null
                      ? '${visita.duracaoPrevista} min'
                      : '-',
                ),
                if (visita.duracaoReal != null)
                  _InfoRow(
                    label: 'Duração Real',
                    value: '${visita.duracaoReal} min',
                  ),
              ],
            ),
            const SizedBox(height: 16),

            _SectionCard(
              title: 'Objetivo & Observações',
              children: [
                _InfoRow(label: 'Objetivo', value: visita.objetivo ?? '-'),
                _InfoRow(label: 'Observação', value: visita.observacao ?? '-'),
                if (visita.resultado != null)
                  _InfoRow(label: 'Resultado', value: visita.resultado!),
              ],
            ),
            const SizedBox(height: 16),

            if (visita.pedidoGerado) ...[
              _SectionCard(
                title: 'Pedido Vinculado',
                children: [
                  _InfoRow(
                    label: 'Pedido ID',
                    value: visita.pedidoId?.toString() ?? '-',
                  ),
                  _InfoRow(
                    label: 'Valor',
                    value: visita.valorPedido != null
                        ? 'R\$ ${visita.valorPedido!.toStringAsFixed(2)}'
                        : '-',
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Sync status
            _SectionCard(
              title: 'Sincronização',
              children: [
                _InfoRow(
                  label: 'Sincronizado',
                  value: visita.sincronizado ? 'Sim' : 'Não',
                ),
                if (visita.criadoOffline)
                  const _InfoRow(label: 'Criado Offline', value: 'Sim'),
              ],
            ),
            const SizedBox(height: 24),

            // Check-ins section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Check-ins', style: kTestStyleBoldText18),
                IconButton(
                  onPressed: () =>
                      _mostrarDialogCheckin(context, viewModel.checkinsTipos),
                  icon: Icon(
                    Icons.add_circle,
                    color: kColorStylePrimaryNeutralPaletteDarkDefault,
                  ),
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (viewModel.checkins.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('Nenhum check-in registrado.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.checkins.length,
                itemBuilder: (context, index) {
                  final checkin = viewModel.checkins[index];
                  return _CheckinCard(checkin: checkin);
                },
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _mostrarDialogCheckin(
    BuildContext context,
    List<CheckinsTipoResponse> checkinsTipos,
  ) {
    CheckinsTipoResponse? tipoSelecionado;
    final observacaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Registrar Check-in'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomDropdownButtonFormField<CheckinsTipoResponse>(
                      hint: 'Tipo de check-in',
                      items: checkinsTipos,
                      itemLabelBuilder: (t) => t.descricaoCheckinTipo ?? '-',
                      selectedValue: tipoSelecionado,
                      onChanged: (t) {
                        setDialogState(() {
                          tipoSelecionado = t;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextfieldMedium(
                      labelText: 'Observação',
                      controller: observacaoController,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                CustomButtonPrimary(
                  label: 'Registrar',
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    ref
                        .read(agendaVisitaDetalheViewModelProvider.notifier)
                        .adicionarCheckin(
                          checkinTipo: tipoSelecionado,
                          observacao: observacaoController.text.isNotEmpty
                              ? observacaoController.text
                              : null,
                        );
                  },
                  trailingIcon: Icons.check,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: kTestStyleBoldText16),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: kTestStyleMediumText14),
          ),
          Expanded(child: Text(value, style: kTestStyleRegularText14)),
        ],
      ),
    );
  }
}

class _CheckinCard extends StatelessWidget {
  final AgendaVisitaCheckinResponse checkin;

  const _CheckinCard({required this.checkin});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  checkin.checkinTipoNome ?? 'Check-in',
                  style: kTestStyleBoldText14,
                ),
                Icon(
                  checkin.sincronizado ? Icons.cloud_done : Icons.cloud_off,
                  size: 18,
                  color: checkin.sincronizado ? Colors.green : Colors.orange,
                ),
              ],
            ),
            if (checkin.observacao != null && checkin.observacao!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  checkin.observacao!,
                  style: kTestStyleRegularText14,
                ),
              ),
            if (checkin.auditoria?.criadoEm != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _formatDateTime(checkin.auditoria!.criadoEm!),
                  style: kTestStyleRegularText12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
