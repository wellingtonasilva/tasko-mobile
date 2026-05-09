import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/card/custom_simple_item_list_card.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_supervisor_response.dart';
import 'package:tasko_mobile/ui/feature/supervisor/listar/supervisor_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/supervisor/listar/supervisor_listar_view_model.dart';

class SupervisorListarScreen extends BaseScreen {
  const SupervisorListarScreen({super.key});

  @override
  BaseScreenState<SupervisorListarScreen> createState() =>
      _SupervisorListarScreenState();
}

class _SupervisorListarScreenState
    extends BaseScreenState<SupervisorListarScreen> {
  late final SupervisorListarControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = SupervisorListarControllers();
    _controllers.pesquisarSupervisor.controller.addListener(
      _onPesquisarChanged,
    );
  }

  @override
  void dispose() {
    _controllers.pesquisarSupervisor.controller.removeListener(
      _onPesquisarChanged,
    );
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(supervisorListarViewModelProvider);
    final supervisoresFiltrados = _filtrarSupervisores(
      viewModel.supervisores ?? [],
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.listarSupervisoresCommand.execute();
          },
          child: SingleChildScrollView(
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
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Supervisores',
                              style: kTestStyleBoldText24,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Supervisor',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'supervisor-adicionar',
                            );
                            if (adicionado == true) {
                              showSnackBar(
                                'Supervisor adicionado com sucesso!',
                              );
                              ref
                                  .read(supervisorListarViewModelProvider)
                                  .listarSupervisoresCommand
                                  .execute();
                            }
                          },
                          trailingIcon: Icons.add,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                          _controllers.pesquisarSupervisor,
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
                            viewModel.listarSupervisoresCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : supervisoresFiltrados.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers
                                                .pesquisarSupervisor
                                                .controller
                                                .text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhum supervisor encontrado.'
                                            : 'Nenhum supervisor encontrado para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: supervisoresFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final supervisor =
                                          supervisoresFiltrados[index];
                                      return CustomSimpleItemListCard(
                                        title: supervisor.nomeSupervisor ?? '',
                                        subtitle: 'ID: ${supervisor.id}',
                                        onTap: _onCustomSimpleItemListCardTap,
                                        id: supervisor.id,
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
      'supervisor-manter',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Supervisor atualizado com sucesso!');
      ref
          .read(supervisorListarViewModelProvider)
          .listarSupervisoresCommand
          .execute();
    }
  }

  List<VendedorSupervisorResponse> _filtrarSupervisores(
    List<VendedorSupervisorResponse> supervisores,
  ) {
    final pesquisa = _controllers.pesquisarSupervisor.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return supervisores;
    }

    return supervisores.where((supervisor) {
      final nome = supervisor.nomeSupervisor?.toLowerCase() ?? '';

      return nome.contains(pesquisa);
    }).toList();
  }
}
