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
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_item_request.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pagamento/pedido_adicionar_produto_controllers.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pedido_adicionar_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pagamento/pedido_criar_pagamento_screen.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pagamento/widgets/custom_condicao_pagamento_button.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pagamento/widgets/custom_forma_pagamento_button.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoAdicionarPagamentoScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoAdicionarPagamentoScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<PedidoAdicionarPagamentoScreen> createState() =>
      _PedidoAdicionarPagamentoScreenState();
}

class _PedidoAdicionarPagamentoScreenState
    extends BaseScreenState<PedidoAdicionarPagamentoScreen> {
  late final PedidoAdicionarProdutoControllers _controllers;

  int selectedPaymentMethodIndex = 0;
  int selectedPaymentConditionIndex = 0;
  int selectedParcelasIndex = 0;

  @override
  void initState() {
    super.initState();
    final draftViewModel = ref.read(pedidoAdicionarViewModelProvider.notifier);
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
  }

  /*
  final List<CondicaoPagamento> paymentConditions = [
    CondicaoPagamento(id: '1', nome: 'À vista'),
    CondicaoPagamento(id: '2', nome: '30 dias'),
    CondicaoPagamento(id: '3', nome: '60 dias'),
    CondicaoPagamento(id: '4', nome: '90 dias'),
  ];
    */

  final List<Parcelas> parcelas = [
    Parcelas(id: '1', nome: '1x'),
    Parcelas(id: '2', nome: '2x'),
    Parcelas(id: '3', nome: '3x'),
    Parcelas(id: '4', nome: '4x'),
    Parcelas(id: '5', nome: '5x'),
    Parcelas(id: '6', nome: '6x'),
  ];

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(pedidoAdicionarViewModelProvider);
    final state = ref.read(pedidoAdicionarViewModelProvider);

    final vmMetodoIndex = viewModel.formaPagamentoNome == null
        ? -1
        : viewModel.formasPagamento?.indexWhere(
                (m) => m.nome == viewModel.formaPagamentoNome,
              ) ??
              -1;
    final vmCondicaoIndex = viewModel.condicaoPagamentoNome == null
        ? -1
        : viewModel.condicoesPagamento?.indexWhere(
                (c) =>
                    c.descricaoCondicaoPagamento ==
                    viewModel.condicaoPagamentoNome,
              ) ??
              -1;

    final effectivePaymentMethodIndex = vmMetodoIndex >= 0
        ? vmMetodoIndex
        : selectedPaymentMethodIndex;
    final effectivePaymentConditionIndex = vmCondicaoIndex >= 0
        ? vmCondicaoIndex
        : selectedPaymentConditionIndex;

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
                            '(3/4)',
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
                                    active: true,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Revisão",
                                    active: false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              Text(
                                'Forma de pagamento',
                                style: kTestStyleBoldText16.copyWith(
                                  color: kColorStyleSecondinaryDarkDefault,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      viewModel.formasPagamento?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final paymentMethod =
                                        viewModel.formasPagamento![index];
                                    return SizedBox(
                                      width: 115,
                                      child: CustomFormaPagamentoButton(
                                        filename: paymentMethod.icone,
                                        title: paymentMethod.nome,
                                        selected:
                                            index ==
                                            effectivePaymentMethodIndex,
                                        onPressed: () {
                                          setState(() {
                                            selectedPaymentMethodIndex = index;
                                          });
                                          ref
                                              .read(
                                                pedidoAdicionarViewModelProvider
                                                    .notifier,
                                              )
                                              .setFormaPagamento(
                                                viewModel
                                                    .formasPagamento![index]
                                                    .nome,
                                              );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 25),
                              Text(
                                'Condição de pagamento',
                                style: kTestStyleBoldText16.copyWith(
                                  color: kColorStyleSecondinaryDarkDefault,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      viewModel.condicoesPagamento?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final paymentCondition =
                                        viewModel.condicoesPagamento![index];
                                    return SizedBox(
                                      width: 85,
                                      child: CustomCondicaoPagamentoButton(
                                        title:
                                            paymentCondition
                                                .descricaoCondicaoPagamento ??
                                            '',
                                        selected:
                                            index ==
                                            effectivePaymentConditionIndex,
                                        onPressed: () {
                                          setState(() {
                                            selectedPaymentConditionIndex =
                                                index;
                                          });
                                          ref
                                              .read(
                                                pedidoAdicionarViewModelProvider
                                                    .notifier,
                                              )
                                              .setCondicaoPagamento(
                                                viewModel
                                                        .condicoesPagamento![index]
                                                        .descricaoCondicaoPagamento ??
                                                    '',
                                              );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 25),

                              /*
                              Row(
                                children: [
                                  Text(
                                    'Parcelas',
                                    style: kTestStyleBoldText16.copyWith(
                                      color: kColorStyleSecondinaryDarkDefault,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '(Opcional)',
                                    style: kTestStyleBoldText14.copyWith(
                                      color: kColorStyleSecondinaryDark400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: parcelas.length,
                                  itemBuilder: (context, index) {
                                    final parcela = parcelas[index];
                                    return SizedBox(
                                      width: 55,
                                      child: CustomCondicaoPagamentoButton(
                                        title: parcela.nome,
                                        selected:
                                            index == selectedParcelasIndex,
                                        onPressed: () {
                                          setState(() {
                                            selectedParcelasIndex = index;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 25),
                              */
                            ],
                          ),
                        ),
                      ),

                      Container(
                        height: 150,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "Resumo do pedido",
                              style: kTestStyleMediumText14.copyWith(
                                color: kColorStyleSecondinaryDark400,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Subtotal (${state.totalItens} iten${state.totalItens == 1 ? '' : 's'})",
                                    style: kTestStyleMediumText14.copyWith(
                                      color: kColorStyleSecondinaryDark400,
                                    ),
                                  ),
                                ),
                                Text(
                                  "R\$ ${state.valorTotal.toStringAsFixed(2)}",
                                  style: kTestStyleMediumText14.copyWith(
                                    color: kColorStyleSecondinaryDark400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(color: kColorStyleSecondinaryLight200),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total do pedido",
                                    style: kTestStyleMediumText18.copyWith(
                                      color: kColorStyleSecondinaryDarkDefault,
                                    ),
                                  ),
                                ),
                                Text(
                                  "R\$ ${state.valorTotal.toStringAsFixed(2)}",
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
                                widget.onPrevious("Pagamento");
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
    final draftState = ref.read(pedidoAdicionarViewModelProvider);
    if (draftState.pedido == null) {
      showSnackBar('Rascunho do pedido não encontrado', isError: true);
      return;
    }

    final pagamentoState = ref.read(pedidoAdicionarViewModelProvider);
    final vmMetodoIndex = pagamentoState.formaPagamentoNome == null
        ? -1
        : draftState.formasPagamento?.indexWhere(
                (m) => m.nome == pagamentoState.formaPagamentoNome,
              ) ??
              -1;
    final vmCondicaoIndex = pagamentoState.condicaoPagamentoNome == null
        ? -1
        : draftState.condicoesPagamento?.indexWhere(
                (c) =>
                    c.descricaoCondicaoPagamento ==
                    pagamentoState.condicaoPagamentoNome,
              ) ??
              -1;

    final effectivePaymentMethodIndex = vmMetodoIndex >= 0
        ? vmMetodoIndex
        : selectedPaymentMethodIndex;
    final effectivePaymentConditionIndex = vmCondicaoIndex >= 0
        ? vmCondicaoIndex
        : selectedPaymentConditionIndex;

    final formaPagamento =
        draftState.formasPagamento?[effectivePaymentMethodIndex];
    final condicao =
        draftState.condicoesPagamento?[effectivePaymentConditionIndex];
    final pedido = draftState.pedido!;
    if (pedido.id == 0) {
      showSnackBar('Rascunho inválido. Reinicie o fluxo.', isError: true);
      return;
    }

    final produtoState = ref.read(pedidoAdicionarViewModelProvider);
    final itens = produtoState.carrinhoQuantidades.entries.map((e) {
      final produto = produtoState.produtos!.firstWhere((p) => p.id == e.key);
      final preco = produto.precoSugerido ?? 0;
      final total = preco * e.value;
      return AdicionarPedidoItemRequest(
        pedidoId: pedido.id,
        produtoId: produto.id ?? 0,
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
      formaPagamentoNome: formaPagamento?.nome,
      condicaoPagamentoNome: condicao?.descricaoCondicaoPagamento,
      pedidoStatusTipoNome: 'Aguardando Pagamento',
      substituirItens: true,
    );

    await draftState.atualizarRascunhoCommand.execute(args);

    if (draftState.atualizarRascunhoCommand.completed && mounted) {
      widget.onNext('Pagamento');
    }
  }
}
