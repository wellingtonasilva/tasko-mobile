import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/cliente/pedido_criar_cliente_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pagamento/widgets/custom_condicao_pagamento_button.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pagamento/widgets/custom_forma_pagamento_button.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_rascunho_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/produto/pedido_criar_produto_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class FormaPagamento {
  final String id;
  final String nome;
  final String icone;

  FormaPagamento({required this.id, required this.nome, required this.icone});
}

class CondicaoPagamento {
  final String id;
  final String nome;

  CondicaoPagamento({required this.id, required this.nome});
}

class Parcelas {
  final String id;
  final String nome;

  Parcelas({required this.id, required this.nome});
}

class PedidoCriarPagamentoScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoCriarPagamentoScreen({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  BaseScreenState<PedidoCriarPagamentoScreen> createState() =>
      _PedidoCriarPagamentoScreenState();
}

class _PedidoCriarPagamentoScreenState
    extends BaseScreenState<PedidoCriarPagamentoScreen> {
  int selectedPaymentMethodIndex = 0;
  int selectedPaymentConditionIndex = 0;
  int selectedParcelasIndex = 0;

  @override
  void initState() {
    super.initState();
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
  }

  final List<FormaPagamento> paymentMethods = [
    FormaPagamento(
      id: '1',
      nome: 'Dinheiro',
      icone: 'assets/images/pos_icon_money.svg',
    ),
    FormaPagamento(
      id: '2',
      nome: 'Cartão',
      icone: 'assets/images/pos_icon_credit_card.svg',
    ),
    FormaPagamento(
      id: '3',
      nome: 'Pix',
      icone: 'assets/images/pos_icon_pix.svg',
    ),
  ];

  final List<CondicaoPagamento> paymentConditions = [
    CondicaoPagamento(id: '1', nome: 'À vista'),
    CondicaoPagamento(id: '2', nome: '30 dias'),
    CondicaoPagamento(id: '3', nome: '60 dias'),
    CondicaoPagamento(id: '4', nome: '90 dias'),
  ];

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
                                  itemCount: paymentMethods.length,
                                  itemBuilder: (context, index) {
                                    final paymentMethod = paymentMethods[index];
                                    return SizedBox(
                                      width: 115,
                                      child: CustomFormaPagamentoButton(
                                        filename: paymentMethod.icone,
                                        title: paymentMethod.nome,
                                        selected:
                                            index == selectedPaymentMethodIndex,
                                        onPressed: () {
                                          setState(() {
                                            selectedPaymentMethodIndex = index;
                                          });
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
                                  itemCount: paymentConditions.length,
                                  itemBuilder: (context, index) {
                                    final paymentCondition =
                                        paymentConditions[index];
                                    return SizedBox(
                                      width: 85,
                                      child: CustomCondicaoPagamentoButton(
                                        title: paymentCondition.nome,
                                        selected:
                                            index ==
                                            selectedPaymentConditionIndex,
                                        onPressed: () {
                                          setState(() {
                                            selectedPaymentConditionIndex =
                                                index;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 25),
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
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                                      "Subtotal (3 itens)",
                                      style: kTestStyleMediumText14.copyWith(
                                        color: kColorStyleSecondinaryDark400,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$ 150,00",
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
                                        color:
                                            kColorStyleSecondinaryDarkDefault,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$ 150,00",
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
    final draftState = ref.read(pedidoCriarRascunhoViewModelProvider);
    if (draftState.pedido == null) {
      showSnackBar('Rascunho do pedido não encontrado', isError: true);
      return;
    }

    final formaPagamento = paymentMethods[selectedPaymentMethodIndex];
    final condicao = paymentConditions[selectedPaymentConditionIndex];
    final pedido = draftState.pedido!;

    final produtoState = ref.read(pedidoCriarProdutoViewModelProvider);
    final itens = produtoState.carrinhoQuantidades.entries.map((e) {
      final produto = produtoState.produtos!.firstWhere((p) => p.id == e.key);
      final preco = produto.precoSugerido ?? 0;
      return (
        pedidoId: pedido.id,
        produtoId: produto.id,
        quantidade: e.value,
        preco: preco,
      );
    }).toList();

    final subtotal = itens.fold(0.0, (sum, i) => sum + i.preco * i.quantidade);

    final request = AdicionarPedidoRequest(
      clienteId: pedido.clienteId,
      vendedorId: pedido.vendedorId,
      dataPedido: pedido.dataPedido.toIso8601String(),
      subtotal: subtotal,
      valorTotal: subtotal,
      latitude: pedido.latitude,
      longitude: pedido.longitude,
    );

    await draftState.atualizarRascunhoCommand.execute((
      pedidoId: pedido.id,
      request: request,
      itens: const [],
      formaPagamentoNome: formaPagamento.nome,
      condicaoPagamentoNome: condicao.nome,
      pedidoStatusTipoNome: null,
      substituirItens: false,
    ));

    final updated = ref.read(pedidoCriarRascunhoViewModelProvider);
    if (updated.pedido != null && mounted) {
      widget.onNext('Pagamento');
    }
  }
}
