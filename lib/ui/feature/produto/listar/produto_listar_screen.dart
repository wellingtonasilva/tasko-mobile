import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/dashboard/custom_dashboard_card_default.dart';
import 'package:tasko_mobile/common/widgets/list/custom_list_view.dart';
import 'package:tasko_mobile/domain/produto/response/produto_grupo_response.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/ui/feature/produto/listar/produto_listar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoListarScreen extends BaseScreen {
  const ProdutoListarScreen({super.key});

  @override
  BaseScreenState<ProdutoListarScreen> createState() =>
      _ProdutoListarScreenState();
}

class _ProdutoListarScreenState extends BaseScreenState<ProdutoListarScreen> {
  final _buscaController = TextEditingController();

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(produtoListarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) {
        return;
      }
      showSnackBar(message, isError: result is Failure);
    };
    ref.read(produtoListarViewModelProvider).carregarGruposCommand.execute();
    ref.read(produtoListarViewModelProvider).listarProdutosCommand.execute();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(produtoListarViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            return viewModel.listarProdutosCommand.execute();
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
                        child: Text('Produtos', style: kTestStyleBoldText24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Produto',
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
                          title: 'Total Produtos',
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
                          title: 'Pedidos Abertos',
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
                          title: 'Faturamento Mensal',
                          value: '\$1,412',
                          icon: Image.asset(
                            'assets/images/pos_icon_money_tick.png',
                            //color: kColorStyleSuccessDark500,
                            width: 35,
                          ),
                          iconBackgroundColor: kColorStyleSuccessLightefault,
                        ),
                      ),
                      //CustomContainerDefault(child: LineChart(avgData())),
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
                                            /*
                                context.pushNamed(
                                  Routes.produtoManter.name,
                                  pathParameters: {'id': value.id.toString()},
                                );
                                */
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

  /*
  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(produtoListarViewModelProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.listarProdutosCommand.execute();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Produtos', style: kTestStyleBoldText24),
              const SizedBox(height: 12),
              TextField(
                controller: _buscaController,
                onChanged: (value) {
                  ref
                      .read(produtoListarViewModelProvider.notifier)
                      .atualizarBusca(value);
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar por nome ou codigo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              _FiltroGrupo(
                grupos: viewModel.grupos,
                grupoSelecionadoId: viewModel.grupoSelecionadoId,
                onChanged: (value) {
                  ref
                      .read(produtoListarViewModelProvider.notifier)
                      .selecionarGrupo(value);
                },
              ),
              const SizedBox(height: 12),
              Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Catalogo', style: kTestStyleBoldText16),
                    const SizedBox(height: 8),
                    viewModel.listarProdutosCommand.running
                        ? const Center(child: CircularProgressIndicator())
                        : CustomListView<ProdutoResponse>(
                            values: viewModel.produtos,
                            onTap: (value) {
                              context.pushNamed(
                                'produtos-detalhe',
                                pathParameters: {'id': value.id.toString()},
                              );
                            },
                            getTitle: (value) => value.nomeProduto,
                            getSubtitle: (value) =>
                                'Preco sugerido: ${_formatMoney(value.precoSugerido)}',
                            getSubtitle1: (value) =>
                                'Grupo: ${value.grupoNome ?? '-'}',
                            getSubtitle2: (value) =>
                                'Estoque: ${value.quantidadeDisponivel?.toStringAsFixed(2) ?? '-'}',
                            onDelete: (value, index) {},
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
*/

  String _formatMoney(double? value) {
    if (value == null) return '-';
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  void _excluirProduto(int id, int index, ProdutoResponse produto) {}
}

class _FiltroGrupo extends StatelessWidget {
  const _FiltroGrupo({
    required this.grupos,
    required this.grupoSelecionadoId,
    required this.onChanged,
  });

  final List<ProdutoGrupoResponse> grupos;
  final int? grupoSelecionadoId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int?>(
      initialValue: grupoSelecionadoId,
      decoration: const InputDecoration(
        labelText: 'Filtrar por grupo',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<int?>(value: null, child: Text('Todos')),
        ...grupos.map(
          (grupo) => DropdownMenuItem<int?>(
            value: grupo.id,
            child: Text(grupo.descricaoGrupo),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
