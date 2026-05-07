import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_edit_icon_button.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/container/custom_review_container.dart';
import 'package:tasko_mobile/common/widgets/custom_review_dados.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';

class VendedorManterDadosResumo extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;

  const VendedorManterDadosResumo({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<VendedorManterDadosResumo> createState() =>
      _VendedorManterDadosResumoState();
}

class _VendedorManterDadosResumoState
    extends BaseScreenState<VendedorManterDadosResumo> {
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
                          title: 'Manter Vendedor',
                          onClosePressed: () => context.pop(false),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomStepperItem(
                                        title: "Dados Básicos",
                                        active: true,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                      Expanded(
                                        child: CustomStepperLine(
                                          width: double.infinity,
                                        ),
                                      ),
                                      CustomStepperItem(
                                        title: "Contato e Meta",
                                        active: true,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                      Expanded(
                                        child: CustomStepperLine(
                                          width: double.infinity,
                                        ),
                                      ),
                                      CustomStepperItem(
                                        title: "Revisão",
                                        active: true,
                                        textStyle: kTestStyleRegularText12,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Revisão de Dados',
                                              style: kTestStyleMediumText16
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Confira as informações antes de salvar.',
                                      style: kTestStyleRegularText12.copyWith(
                                        color: kColorStyleSecondinaryDark400,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                                _buildDadosBasicosSection(),
                                const SizedBox(height: 15),
                                _buildDadosContatoSection(),
                                const SizedBox(height: 15),
                                _buildDadosMetaSection(),
                              ],
                            ),
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
                                widget.onPrevious('Dados Básicos');
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Salvar',
                              onPressed: () => widget.onNext('Produto'),
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

  Widget _buildDadosBasicosSection() {
    return CustomReviewContainer(
      label: 'Dados Básicos',
      onEdit: () {
        widget.onPrevious("Dados Básicos");
      },
      children: [
        CustomReviewDados(label: 'Código', value: '12345'),
        const SizedBox(height: 5),
        CustomReviewDados(label: 'Nome', value: 'João Silva'),
        const SizedBox(height: 5),
        CustomReviewDados(label: 'CPF', value: '123.456.789-00'),
        const SizedBox(height: 5),
        CustomReviewDados(label: 'Status', value: 'Ativo'),
      ],
    );
  }

  Widget _buildDadosContatoSection() {
    return CustomReviewContainer(
      label: 'Contato',
      onEdit: () {
        widget.onPrevious("Contato");
      },
      children: [
        CustomReviewDados(label: 'E-mail', value: 'joao.silva@example.com'),
        const SizedBox(height: 5),
        CustomReviewDados(label: 'Telefone', value: '(11) 1234-5678'),
        const SizedBox(height: 5),
        CustomReviewDados(
          label: 'Telefone Alternativo',
          value: '(11) 1234-5678',
        ),
      ],
    );
  }

  Widget _buildDadosMetaSection() {
    return CustomReviewContainer(
      label: 'Meta e Comissão',
      onEdit: () {
        widget.onPrevious("Meta e Comissão");
      },
      children: [
        CustomReviewDados(label: 'Meta Anual', value: 'R\$ 100.000,00'),
        const SizedBox(height: 5),
        CustomReviewDados(label: 'Comissão', value: '% 2'),
      ],
    );
  }
}
