import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/auth_persistence.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/cliente/pedido_criar_cliente_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_rascunho_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/produto/pedido_criar_produto_controllers.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/produto/pedido_criar_produto_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/produto/widgets/produto_card.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoCriarProdutoScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoCriarProdutoScreen({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  BaseScreenState<PedidoCriarProdutoScreen> createState() =>
      _PedidoCriarProdutoScreenState();
}

class _PedidoCriarProdutoScreenState
    extends BaseScreenState<PedidoCriarProdutoScreen> {
  late PedidoCriarProdutoControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoCriarProdutoControllers();

    final viewModel = ref.read(pedidoCriarProdutoViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };
    viewModel.onStartEvent = () {
      if (mounted) {
        showLoading();
      }
    };
    viewModel.onFinishEvent = () {
      if (mounted) {
        hideLoading();
      }
    };

    final draftViewModel = ref.read(
      pedidoCriarRascunhoViewModelProvider.notifier,
    );
    draftViewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };
    draftViewModel.onStartEvent = () {
      if (mounted) showLoading();
    };
    draftViewModel.onFinishEvent = () {
      if (mounted) hideLoading();
    };

    ref
        .read(pedidoCriarProdutoViewModelProvider)
        .listarProdutoCommand
        .execute();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(pedidoCriarProdutoViewModelProvider);
    final clienteViewModel = ref.watch(pedidoCriarClienteViewModelProvider);

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
                              'Pedido - ${clienteViewModel.selectedCliente?.nomeFantasia ?? ''}',
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                              viewModel.produtos?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            final produto =
                                                viewModel.produtos![index];
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
                                                      pedidoCriarProdutoViewModelProvider
                                                          .notifier,
                                                    )
                                                    .setQuantidade(
                                                      produto.id,
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

  Future<void> _handleProximoPressed() async {
    final produtoState = ref.read(pedidoCriarProdutoViewModelProvider);
    final draftState = ref.read(pedidoCriarRascunhoViewModelProvider);

    if (draftState.pedido == null) {
      showSnackBar('Selecione um cliente primeiro', isError: true);
      return;
    }
    if (produtoState.carrinhoQuantidades.isEmpty) {
      showSnackBar('Adicione pelo menos um produto', isError: true);
      return;
    }

    final pedido = draftState.pedido!;
    final itens = produtoState.carrinhoQuantidades.entries.map((e) {
      final produto = produtoState.produtos!.firstWhere((p) => p.id == e.key);
      final preco = produto.precoSugerido ?? 0;
      final total = preco * e.value;
      return AdicionarPedidoItemRequest(
        pedidoId: pedido.id,
        produtoId: produto.id,
        quantidade: e.value,
        precoUnitario: preco,
        valorTotal: total,
      );
    }).toList();

    final subtotal = itens.fold(0.0, (sum, i) => sum + i.valorTotal);
    final request = AdicionarPedidoRequest(
      empresaId:
          (await ref.read(authLocalStorageProvider).getUsuarioLoginResponse())
              ?.empresas
              ?.firstOrNull
              ?.empresaId ??
          0,
      clienteId: pedido.clienteId,
      vendedorId: pedido.vendedorId,
      dataPedido: pedido.dataPedido.toIso8601String(),
      subtotal: subtotal,
      valorTotal: subtotal,
      latitude: pedido.latitude,
      longitude: pedido.longitude,
    );

    final args = (
      pedidoId: pedido.id,
      request: request,
      itens: itens,
      formaPagamentoNome: pedido.formaPagamentoNome,
      condicaoPagamentoNome: pedido.condicaoPagamentoNome,
      pedidoStatusTipoNome: pedido.pedidoStatusTipoNome,
      substituirItens: true,
    );

    await ref
        .read(pedidoCriarRascunhoViewModelProvider)
        .atualizarRascunhoCommand
        .execute(args);

    final updatedDraft = ref.read(pedidoCriarRascunhoViewModelProvider);
    if (updatedDraft.pedido != null && mounted) {
      widget.onNext('Produto');
    }
  }
}
