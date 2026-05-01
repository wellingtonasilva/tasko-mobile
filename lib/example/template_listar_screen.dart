import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/dashboard/custom_dashboard_card_default.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';

class TemplateListarScreen extends BaseScreen {
  const TemplateListarScreen({super.key});

  @override
  BaseScreenState<TemplateListarScreen> createState() =>
      _TemplateListarScreenState();
}

class _TemplateListarScreenState extends BaseScreenState<TemplateListarScreen> {
  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        body: RefreshIndicator(
          onRefresh: () async {
            //await viewModel.listarProdutosCommand.execute();
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Template', style: kTestStyleBoldText24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Template',
                          onPressed: () async {
                            showSnackBar(
                              'Funcionalidade em desenvolvimento',
                              isError: false,
                            );
                            /*
                            final adicionado = await context.pushNamed<bool>(
                              'produtos-adicionar',
                            );
                            if (adicionado == true) {
                              ref
                                  .read(produtoListarViewModelProvider)
                                  .listarProdutosCommand
                                  .execute();
                            }
                            */
                          },
                          trailingIcon: Icons.add,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Total Templates',
                          value: '10',
                          icon: Image.asset(
                            'assets/images/pos_icon_box.png',
                            //color: kColorStylePrimaryNeutralPaletteDark500,
                            width: 35,
                          ),
                          iconBackgroundColor:
                              kColorStylePrimaryNeutralPaletteLight100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Templates Abertos',
                          value: '12',
                          icon: Image.asset(
                            'assets/images/pos_icon_document_text.png',
                            //color: kColorStyleInformationDarkDefault,
                            width: 35,
                          ),
                          iconBackgroundColor:
                              kColorStyleInformationLightDefault,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Template Mensal',
                          value: 'R\$ 1.412',
                          icon: Image.asset(
                            'assets/images/pos_icon_money_tick.png',
                            //color: kColorStyleSuccessDark500,
                            width: 35,
                          ),
                          iconBackgroundColor: kColorStyleSuccessLightefault,
                        ),
                      ),
                      //Lista de produtos
                      /*
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
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    'Lista de Produtos',
                                    style: kTestStyleBoldText16,
                                  ),
                                  const SizedBox(height: 20),
                                  viewModel.listarProdutosCommand.running
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : CustomListView<ProdutoResponse>(
                                          values: viewModel.produtos,
                                          onTap: (value) {
                                            context.pushNamed(
                                              'produtos-detalhe',
                                              pathParameters: {
                                                'id': value.id.toString(),
                                              },
                                            );
                                          },
                                          getTitle: (value) =>
                                              value.nomeProduto,
                                          getSubtitle: (value) =>
                                              value.descricaoProduto ?? '-',

                                          onDelete: (produto, index) {
                                            _excluirProduto(
                                              produto.id,
                                              index,
                                              produto,
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      */
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

  void _excluirProduto(int id, int index, ProdutoResponse produto) {}
}
