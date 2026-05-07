import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/container/custom_review_container.dart';
import 'package:tasko_mobile/common/widgets/custom_review_dados.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/adicionar/vendedor_adicionar_view_model.dart';

class VendedorAdicionarResumoScreen extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;
  final Function(int value) gotoStep;

  const VendedorAdicionarResumoScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.gotoStep,
  });

  @override
  BaseScreenState<VendedorAdicionarResumoScreen> createState() =>
      _VendedorAdicionarResumoScreenState();
}

class _VendedorAdicionarResumoScreenState
    extends BaseScreenState<VendedorAdicionarResumoScreen> {
  VendedorResponse? get _draft {
    final state = ref.watch(vendedorAdicionarViewModelProvider);
    return state.vendedorDraft;
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
                          title: 'Adicionar Vendedor',
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
                              onPressed: _onSalvarPressed,
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
    final draft = _draft;

    return CustomReviewContainer(
      label: 'Dados Básicos',
      onEdit: () {
        widget.gotoStep(0);
      },
      children: [
        CustomReviewDados(label: 'Código', value: draft?.codigoVendedor ?? '-'),
        const SizedBox(height: 5),
        CustomReviewDados(label: 'Nome', value: draft?.nomeVendedor ?? '-'),
        const SizedBox(height: 5),
        CustomReviewDados(label: 'CPF', value: draft?.numeroCPF ?? '-'),
        const SizedBox(height: 5),
        CustomReviewDados(
          label: 'Status',
          value: _formatStatus(draft?.auditoria?.indicadorAtivo),
        ),
      ],
    );
  }

  Widget _buildDadosContatoSection() {
    final draft = _draft;

    return CustomReviewContainer(
      label: 'Contato',
      onEdit: () {
        debugPrint('### Editar Contato');
        widget.gotoStep(1);
      },
      children: [
        CustomReviewDados(label: 'E-mail', value: draft?.email ?? '-'),
        const SizedBox(height: 5),
        CustomReviewDados(
          label: 'Telefone',
          value: draft?.numeroTelefone ?? '-',
        ),
      ],
    );
  }

  Widget _buildDadosMetaSection() {
    final draft = _draft;

    return CustomReviewContainer(
      label: 'Meta e Comissão',
      onEdit: () {
        debugPrint('### Editar Meta e Comissão');
        widget.gotoStep(2);
      },
      children: [
        CustomReviewDados(
          label: 'Meta Mensal',
          value: _formatCurrency(draft?.valorMetaMensal),
        ),
        const SizedBox(height: 5),
        CustomReviewDados(
          label: 'Comissão',
          value: _formatPercent(draft?.percentualComissao),
        ),
      ],
    );
  }

  Future<void> _onSalvarPressed() async {
    await ref.read(vendedorAdicionarViewModelProvider.notifier).enviarResumo();
  }

  String _formatCurrency(double? value) {
    if (value == null) return '-';
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  String _formatPercent(double? value) {
    if (value == null) return '-';
    return '${value.toStringAsFixed(2)}%';
  }

  String _formatStatus(bool? indicadorAtivo) {
    if (indicadorAtivo == null) return '-';
    return indicadorAtivo ? 'Ativo' : 'Inativo';
  }
}
