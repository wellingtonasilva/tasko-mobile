import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/card/custom_simple_item_list_card.dart';
import 'package:tasko_mobile/domain/grupo/response/produto_grupo_response.dart';
import 'package:tasko_mobile/ui/feature/grupo/listar/grupo_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/grupo/listar/grupo_listar_view_model.dart';

class GrupoListarScreen extends BaseScreen {
  const GrupoListarScreen({super.key});

  @override
  BaseScreenState<GrupoListarScreen> createState() => _GrupoListarScreenState();
}

class _GrupoListarScreenState extends BaseScreenState<GrupoListarScreen> {
  late final GrupoListarControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = GrupoListarControllers();
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
    final viewModel = ref.watch(grupoListarViewModelProvider);
    final gruposFiltrados = _filtrarGrupos(viewModel.grupos ?? []);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.listarGruposCommand.execute();
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
                            child: Text('Grupos', style: kTestStyleBoldText24),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Grupo',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'grupos-adicionar',
                            );
                            if (adicionado == true) {
                              showSnackBar('Grupo adicionado com sucesso!');
                              ref
                                  .read(grupoListarViewModelProvider)
                                  .listarGruposCommand
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
                            viewModel.listarGruposCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : gruposFiltrados.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers.pesquisar.controller.text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhum grupo encontrado.'
                                            : 'Nenhum grupo encontrado para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: gruposFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final grupo = gruposFiltrados[index];
                                      return CustomSimpleItemListCard(
                                        title: grupo.descricaoGrupo ?? '',
                                        subtitle: 'ID: ${grupo.id}',
                                        onTap: _onCustomSimpleItemListCardTap,
                                        id: grupo.id,
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
      'grupos-manter',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Grupo atualizado com sucesso!');
      ref.read(grupoListarViewModelProvider).listarGruposCommand.execute();
    }
  }

  List<ProdutoGrupoResponse> _filtrarGrupos(List<ProdutoGrupoResponse> grupos) {
    final pesquisa = _controllers.pesquisar.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return grupos;
    }

    return grupos.where((grupo) {
      final nome = grupo.descricaoGrupo?.toLowerCase() ?? '';

      return nome.contains(pesquisa);
    }).toList();
  }
}
