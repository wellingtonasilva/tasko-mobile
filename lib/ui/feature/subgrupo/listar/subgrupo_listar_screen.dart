import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/card/custom_simple_item_list_card.dart';
import 'package:tasko_mobile/domain/subgrupo/response/produto_subgrupo_response.dart';
import 'package:tasko_mobile/ui/feature/subgrupo/listar/subgrupo_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/subgrupo/listar/subgrupo_listar_view_model.dart';

class SubgrupoListarScreen extends BaseScreen {
  const SubgrupoListarScreen({super.key});

  @override
  BaseScreenState<SubgrupoListarScreen> createState() =>
      _SubgrupoListarScreenState();
}

class _SubgrupoListarScreenState extends BaseScreenState<SubgrupoListarScreen> {
  late final SubgrupoListarControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = SubgrupoListarControllers();
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
    final viewModel = ref.watch(subgrupoListarViewModelProvider);
    final subgruposFiltrados = _filtrarSubgrupos(viewModel.subgrupos ?? []);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.listarSubgruposCommand.execute();
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
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Subgrupos',
                              style: kTestStyleBoldText24,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Subgrupo',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'subgrupos-adicionar',
                            );
                            if (adicionado == true) {
                              showSnackBar('Subgrupo adicionado com sucesso!');
                              ref
                                  .read(subgrupoListarViewModelProvider)
                                  .listarSubgruposCommand
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
                            viewModel.listarSubgruposCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : subgruposFiltrados.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers.pesquisar.controller.text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhum subgrupo encontrado.'
                                            : 'Nenhum subgrupo encontrado para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: subgruposFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final subgrupo =
                                          subgruposFiltrados[index];
                                      return CustomSimpleItemListCard(
                                        title: subgrupo.descricaoSubgrupo ?? '',
                                        subtitle: 'ID: ${subgrupo.id}',
                                        onTap: _onCustomSimpleItemListCardTap,
                                        id: subgrupo.id,
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
      'subgrupos-manter',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Subgrupo atualizado com sucesso!');
      ref
          .read(subgrupoListarViewModelProvider)
          .listarSubgruposCommand
          .execute();
    }
  }

  List<ProdutoSubgrupoResponse> _filtrarSubgrupos(
    List<ProdutoSubgrupoResponse> subgrupos,
  ) {
    final pesquisa = _controllers.pesquisar.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return subgrupos;
    }

    return subgrupos.where((subgrupo) {
      final nome = subgrupo.descricaoSubgrupo?.toLowerCase() ?? '';

      return nome.contains(pesquisa);
    }).toList();
  }
}
