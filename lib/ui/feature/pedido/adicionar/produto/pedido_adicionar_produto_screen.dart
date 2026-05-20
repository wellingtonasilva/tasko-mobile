import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pedido_adicionar_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/produto/pedido_adicionar_produto_controllers.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/produto/widgets/produto_card.dart';

class PedidoAdicionarProdutoScreen extends BaseScreen {
  final Function(String produto) onPrevious;
  final Function(String produto) onNext;

  const PedidoAdicionarProdutoScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<PedidoAdicionarProdutoScreen> createState() =>
      PedidoAdicionarProdutoScreenState();
}

class PedidoAdicionarProdutoScreenState
    extends BaseScreenState<PedidoAdicionarProdutoScreen> {
  late final PedidoAdicionarProdutoControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoAdicionarProdutoControllers();
    _controllers.pesquisaProduto.controller.addListener(_onPesquisarChanged);
  }

  @override
  void dispose() {
    _controllers.pesquisaProduto.controller.removeListener(_onPesquisarChanged);
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(pedidoAdicionarViewModelProvider);
    final filteredProdutos = viewModel.produtos != null
        ? _filtrarProdutos(viewModel.produtos!)
        : null;

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
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: kColorStylePrimary0,
                ),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(
                          title:
                              'Pedido - ${viewModel.selectedCliente?.nomeFantasia ?? ''}',
                          child: Text(
                            '(2/4)',
                            style: kTestStyleBoldText14.copyWith(
                              color: kColorStyleSecondinaryLight400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomStepperItem(
                                    title: "Cliente",
                                    active: true,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Produtos",
                                    active: true,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Pagamento",
                                    active: false,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Revisão",
                                    active: false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              buildTextField(_controllers.pesquisaProduto),
                              const SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  viewModel.listarProdutoCommand.running
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              filteredProdutos?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            final produto =
                                                filteredProdutos![index];
                                            return ProdutoCard(
                                              produto: produto,
                                              quantidade:
                                                  viewModel
                                                      .carrinhoQuantidades[produto
                                                      .id] ??
                                                  0,
                                              onQuantidadeChanged: (q) {
                                                ref
                                                    .read(
                                                      pedidoAdicionarViewModelProvider
                                                          .notifier,
                                                    )
                                                    .setQuantidade(
                                                      produto.id ?? 0,
                                                      q,
                                                    );
                                              },
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 75,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 30,
                                color: kColorStyleSecondinaryDark400,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${viewModel.totalItens} iten${viewModel.totalItens == 1 ? '' : 's'}",
                                  style: kTestStyleMediumText18.copyWith(
                                    color: kColorStyleSecondinaryDark400,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Total",
                                    style: kTestStyleMediumText16.copyWith(
                                      color: kColorStyleSecondinaryDark400,
                                    ),
                                  ),
                                  Text(
                                    "R\$ ${viewModel.valorTotal.toStringAsFixed(2)}",
                                    style: kTestStyleBoldText18.copyWith(
                                      color:
                                          kColorStylePrimaryNeutralPaletteDark500,
                                    ),
                                  ),
                                ],
                              ),
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
                              label: 'Voltar',
                              onPressed: () {
                                widget.onPrevious('Produto');
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Próximo',
                              onPressed: () => _handleProximoPressed(),
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
      ),
    );
  }

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<ProdutoResponse> _filtrarProdutos(List<ProdutoResponse> produtos) {
    final pesquisa = _controllers.pesquisaProduto.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return produtos;
    }

    return produtos.where((produto) {
      final nome = produto.nomeProduto?.toLowerCase() ?? '';
      final descricao = produto.descricaoProduto?.toLowerCase() ?? '';

      return nome.contains(pesquisa) || descricao.contains(pesquisa);
    }).toList();
  }

  void _handleProximoPressed() {}
}
