import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_category_button.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pagamento/widgets/custom_forma_pagamento_button.dart';

class FormaPagamento {
  final String id;
  final String nome;
  final String icone;

  FormaPagamento({required this.id, required this.nome, required this.icone});
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

  @override
  Widget buildContent(BuildContext context) {
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
                          title: 'Novo Pedido',
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
                              onPressed: () {
                                widget.onNext("Pagamento");
                              },
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
}
