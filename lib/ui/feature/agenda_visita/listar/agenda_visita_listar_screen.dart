import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/card/custom_simple_item_list_card.dart';
import 'package:tasko_mobile/domain/agenda_visita/response/agenda_visita_response.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/listar/agenda_visita_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/listar/agenda_visita_listar_view_model.dart';
import 'package:tasko_mobile/ui/feature/agenda_visita/listar/widgets/agenda_visita_list_item_card.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/widgets/pedido_item_status_helper.dart';

class AgendaVisitaListarScreen extends BaseScreen {
  const AgendaVisitaListarScreen({super.key});

  @override
  BaseScreenState<AgendaVisitaListarScreen> createState() =>
      _AgendaVisitaListarScreenState();
}

class _AgendaVisitaListarScreenState
    extends BaseScreenState<AgendaVisitaListarScreen> {
  @override
  bool get useScaffold => false;
  late final AgendaVisitaListarControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = AgendaVisitaListarControllers();
    _controllers.pesquisar.controller.addListener(_onPesquisarChanged);
  }

  @override
  void dispose() {
    _controllers.pesquisar.controller.removeListener(_onPesquisarChanged);
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(agendaVisitaListarViewModelProvider);
    final agendaVisitasFiltradas = _filtrar(viewModel.visitas ?? []);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.listarVisitasCommand.execute();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(color: kColorStylePrimary100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Agenda de Visitas',
                              style: kTestStyleBoldText24,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Agenda de Visita',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'agenda-visita-adicionar',
                            );
                            if (adicionado == true) {
                              showSnackBar(
                                'Agenda de visita adicionada com sucesso!',
                              );
                              ref
                                  .read(agendaVisitaListarViewModelProvider)
                                  .listarVisitasCommand
                                  .execute();
                            }
                          },
                          trailingIcon: Icons.add,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                          _controllers.pesquisar,
                          isShowHint: true,
                          topPadding: 0,
                        ),
                      ),
                      //Listaagem
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            viewModel.listarVisitasCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : agendaVisitasFiltradas.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers.pesquisar.controller.text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhuma agenda de visita encontrada.'
                                            : 'Nenhuma agenda de visita encontrada para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: agendaVisitasFiltradas.length,
                                    itemBuilder: (context, index) {
                                      final agendaVisita =
                                          agendaVisitasFiltradas[index];
                                      return AgendaVisitaListItemCard(
                                        visita: agendaVisita,
                                        status: PedidoSyncStatus.pendente,
                                        onTap: _onCustomSimpleItemListCardTap,
                                      );
                                    },
                                  ),
                          ],
                        ),
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

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onCustomSimpleItemListCardTap(int id) async {
    final atualizado = await context.pushNamed<bool>(
      'agenda-visita-manter',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Agenda de visita atualizada com sucesso!');
      ref
          .read(agendaVisitaListarViewModelProvider)
          .listarVisitasCommand
          .execute();
    }
  }

  List<AgendaVisitaResponse> _filtrar(
    List<AgendaVisitaResponse> agendaVisitas,
  ) {
    final pesquisa = _controllers.pesquisar.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return agendaVisitas;
    }

    return agendaVisitas.where((agendaVisita) {
      final nome = agendaVisita.razaoSocial?.toLowerCase() ?? '';

      return nome.contains(pesquisa);
    }).toList();
  }
}


/*   

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(agendaVisitaListarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) return;
      if (result is Success) {
        showSnackBar(message, isError: false);
      } else {
        showSnackBar(message, isError: true);
      }
    };
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateHeader(DateTime date) {
    const dias = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    final diaSemana = dias[date.weekday - 1];
    return '$diaSemana, ${_formatDate(date)}';
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(agendaVisitaListarViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await viewModel.listarVisitasCommand.execute();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(color: kColorStylePrimary100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Agenda de Visitas',
                        style: kTestStyleBoldText24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonPrimary(
                        label: 'Nova Visita',
                        onPressed: () async {
                          final adicionado = await context.pushNamed<bool>(
                            'agenda-criar',
                          );
                          if (adicionado == true) {
                            await ref
                                .read(agendaVisitaListarViewModelProvider)
                                .listarVisitasCommand
                                .execute();
                          }
                        },
                        trailingIcon: Icons.add,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildDateSelector(viewModel),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 200),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: kColorStyleSecondinaryDark200,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatDateHeader(viewModel.dataSelecionada),
                                  style: kTestStyleBoldText16,
                                ),
                                const SizedBox(height: 20),
                                viewModel.listarVisitasCommand.running
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : viewModel.visitas.isEmpty
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(24.0),
                                          child: Text(
                                            'Nenhuma visita agendada para esta data.',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : CustomListView<AgendaVisitaResponse>(
                                        values: viewModel.visitas,
                                        onTap: (value) {
                                          context.pushNamed(
                                            'agenda-manter',
                                            pathParameters: {
                                              'id': value.id.toString(),
                                            },
                                          );
                                        },
                                        getTitle: (value) =>
                                            value.objetivo ??
                                            'Visita #${value.id}',
                                        getSubtitle: (value) =>
                                            _formatDate(value.dataAgendada),
                                        getSubtitle1: (value) =>
                                            value.agendaVisitaStatusNome ?? '-',
                                        getSubtitle2: (value) =>
                                            value.duracaoPrevista != null
                                            ? '${value.duracaoPrevista} min'
                                            : '-',
                                        onDelete: (visita, index) {
                                          _excluirVisita(
                                            visita.id,
                                            index,
                                            visita,
                                          );
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildDateSelector(dynamic viewModel) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            final notifier = ref.read(
              agendaVisitaListarViewModelProvider.notifier,
            );
            notifier.selecionarData(
              viewModel.dataSelecionada.subtract(const Duration(days: 1)),
            );
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: viewModel.dataSelecionada,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                ref
                    .read(agendaVisitaListarViewModelProvider.notifier)
                    .selecionarData(picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kColorStyleSecondinaryDark200),
              ),
              child: Text(
                _formatDateHeader(viewModel.dataSelecionada),
                textAlign: TextAlign.center,
                style: kTestStyleBoldText16,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            final notifier = ref.read(
              agendaVisitaListarViewModelProvider.notifier,
            );
            notifier.selecionarData(
              viewModel.dataSelecionada.add(const Duration(days: 1)),
            );
          },
        ),
      ],
    );
  }

  void _excluirVisita(
    int id,
    int indexRemovido,
    AgendaVisitaResponse visitaRemovida,
  ) async {
    final viewModel = ref.read(agendaVisitaListarViewModelProvider);

    setState(() {
      viewModel.visitas.removeAt(indexRemovido);
    });

    await viewModel.excluirVisitaCommand.execute(id);
    final result = viewModel.excluirVisitaCommand.result;

    if (result is Failure && mounted) {
      setState(() {
        viewModel.visitas.insert(indexRemovido, visitaRemovida);
      });
    }
  }
}
*/