import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/card/custom_simple_item_list_card.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_territorio_response.dart';
import 'package:tasko_mobile/ui/feature/territorio/listar/territorio_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/territorio/listar/territorio_listar_view_model.dart';

class TerritorioListarScrren extends BaseScreen {
  const TerritorioListarScrren({super.key});

  @override
  BaseScreenState<TerritorioListarScrren> createState() =>
      _TerritorioListarScrrenState();
}

class _TerritorioListarScrrenState
    extends BaseScreenState<TerritorioListarScrren> {
  late final TerritorioListarControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = TerritorioListarControllers();
    _controllers.pesquisarTerritorio.controller.addListener(
      _onPesquisarChanged,
    );
  }

  @override
  void dispose() {
    _controllers.pesquisarTerritorio.controller.removeListener(
      _onPesquisarChanged,
    );
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(territorioListarViewModelProvider);
    final territoriosFiltrados = _filtrarTerritorios(viewModel.territorios);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.listarTerritoriosCommand.execute();
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
                              'Território',
                              style: kTestStyleBoldText24,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Território',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'territorio-adicionar',
                            );
                            if (adicionado == true) {
                              ref
                                  .read(territorioListarViewModelProvider)
                                  .listarTerritoriosCommand
                                  .execute();
                            }
                          },
                          trailingIcon: Icons.add,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                          _controllers.pesquisarTerritorio,
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
                            viewModel.listarTerritoriosCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : territoriosFiltrados.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers
                                                .pesquisarTerritorio
                                                .controller
                                                .text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhum território encontrado.'
                                            : 'Nenhum território encontrado para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: territoriosFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final territorio =
                                          territoriosFiltrados[index];
                                      return CustomSimpleItemListCard(
                                        title:
                                            territorio.descricaoTerritorio ??
                                            '',
                                        subtitle: territorio.nomeRegiao ?? '',
                                        onTap: _onCustomSimpleItemListCardTap,
                                        id: territorio.id,
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
      'territorio-manter',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Território atualizado com sucesso!');
      ref
          .read(territorioListarViewModelProvider)
          .listarTerritoriosCommand
          .execute();
    }
  }

  List<VendedorTerritorioResponse> _filtrarTerritorios(
    List<VendedorTerritorioResponse> territorios,
  ) {
    final pesquisa = _controllers.pesquisarTerritorio.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return territorios;
    }

    return territorios.where((territorio) {
      final nome = territorio.descricaoTerritorio?.toLowerCase() ?? '';
      final codigo = territorio.nomeRegiao?.toLowerCase() ?? '';

      return nome.contains(pesquisa) || codigo.contains(pesquisa);
    }).toList();
  }
}
