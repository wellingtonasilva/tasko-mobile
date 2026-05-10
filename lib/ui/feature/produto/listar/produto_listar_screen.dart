import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/ui/feature/produto/listar/produto_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/produto/listar/produto_listar_view_model.dart';
import 'package:tasko_mobile/ui/feature/produto/listar/widgets/custom_produto_item_card.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoListarScreen extends BaseScreen {
  const ProdutoListarScreen({super.key});

  @override
  BaseScreenState<ProdutoListarScreen> createState() =>
      _ProdutoListarScreenState();
}

class _ProdutoListarScreenState extends BaseScreenState<ProdutoListarScreen> {
  late final ProdutoListarControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = ProdutoListarControllers();
    _controllers.pesquisar.controller.addListener(_onPesquisarChanged);

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
    _controllers.dispose();
    _controllers.pesquisar.controller.removeListener(_onPesquisarChanged);
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(produtoListarViewModelProvider);
    final produtosFiltrados = _filtrarProdutos(viewModel.produtos ?? []);

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
                            final adicionado = await context.pushNamed<bool>(
                              'produtos-adicionar',
                            );
                            if (adicionado == true) {
                              showSnackBar('Produto adicionado com sucesso!');
                              ref
                                  .read(produtoListarViewModelProvider)
                                  .listarProdutosCommand
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
                            viewModel.listarProdutosCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : produtosFiltrados.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers.pesquisar.controller.text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhum produto encontrado.'
                                            : 'Nenhum produto encontrado para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: produtosFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final produto = produtosFiltrados[index];
                                      return CustomProdutoItemCard(
                                        produto: produto,
                                        onTap: _onCustomProdutoItemCardTap,
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

  void _excluirProduto(int id, int index, ProdutoResponse produto) {}

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onCustomProdutoItemCardTap(ProdutoResponse produto) async {
    final atualizado = await context.pushNamed<bool>(
      'produtos-manter',
      pathParameters: {'id': produto.id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Produto atualizado com sucesso!');
      ref.read(produtoListarViewModelProvider).listarProdutosCommand.execute();
    }
  }

  List<ProdutoResponse> _filtrarProdutos(List<ProdutoResponse> produtos) {
    final pesquisa = _controllers.pesquisar.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return produtos;
    }

    return produtos.where((produto) {
      final nome = produto.nomeProduto?.toLowerCase() ?? '';

      return nome.contains(pesquisa);
    }).toList();
  }
}
