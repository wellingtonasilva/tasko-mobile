import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/ui/feature/produto/adicionar/precos_margem/produto_adicionar_pecos_margens_controllers.dart';
import 'package:tasko_mobile/ui/feature/produto/adicionar/produto_adicionar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class ProdutoAdicionarPecosMargensScreen extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;

  const ProdutoAdicionarPecosMargensScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<ProdutoAdicionarPecosMargensScreen> createState() =>
      _ProdutoAdicionarPecosMargensScreenState();
}

class _ProdutoAdicionarPecosMargensScreenState
    extends BaseScreenState<ProdutoAdicionarPecosMargensScreen> {
  late final ProdutoAdicionarPecosMargensControllers _controllers;
  String? _hydratedDraftKey;

  @override
  void initState() {
    super.initState();
    _controllers = ProdutoAdicionarPecosMargensControllers();

    final viewModel = ref.read(produtoAdicionarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(produtoAdicionarViewModelProvider);
    final draft = viewModel.produtoDraft;
    final draftKey =
        '${draft?.codigoProduto ?? ''}|${draft?.nomeProduto ?? ''}|${draft?.descricaoProduto ?? ''}';

    if (_hydratedDraftKey != draftKey) {
      _controllers.updateFormFields(draft);
      _hydratedDraftKey = draftKey;
    }

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
                          title: 'Adicionar Produto',
                          onClosePressed: () => context.pop(false),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _controllers.formKey,
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
                                        title: "Preços e Margens",
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
                                              'Preços e Margens',
                                              style: kTestStyleMediumText16
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.precoCusto,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.precoSugerido,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.margemMinima,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: buildTextField(
                                        _controllers.aliquotaIcms,
                                        isMandatory: true,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: buildTextField(
                                        _controllers.aliquotaIpi,
                                        isMandatory: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Estoque',
                                  style: kTestStyleMediumText16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: buildTextField(
                                        _controllers.quantidadeDisponivel,
                                        isMandatory: true,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: buildTextField(
                                        _controllers.quantidadeReservada,
                                        isMandatory: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Dimensões e Peso',
                                  style: kTestStyleMediumText16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: buildTextField(
                                        _controllers.pesoLiquido,
                                        isMandatory: true,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: buildTextField(
                                        _controllers.dimensaoAltura,
                                        isMandatory: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: buildTextField(
                                        _controllers.dimensaoLargura,
                                        isMandatory: true,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: buildTextField(
                                        _controllers.dimensaoProfundidade,
                                        isMandatory: true,
                                      ),
                                    ),
                                  ],
                                ),
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
                                _onPreviousPressed();
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Salvar',
                              onPressed: _onNextPressed,
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

  void _onPreviousPressed() {
    widget.onPrevious('Dados Básicos');
  }

  void _onNextPressed() {
    if (!(_controllers.formKey.currentState?.validate() ?? false)) return;

    ref
        .read(produtoAdicionarViewModelProvider.notifier)
        .salvarDadosPrecosMargens(
          precoCusto:
              double.tryParse(_controllers.precoCusto.controller.text) ?? 0,
          precoSugerido:
              double.tryParse(_controllers.precoSugerido.controller.text) ?? 0,
          margemMinima:
              double.tryParse(_controllers.margemMinima.controller.text) ?? 0,
          aliquotaIcms:
              double.tryParse(_controllers.aliquotaIcms.controller.text) ?? 0,
          aliquotaIpi:
              double.tryParse(_controllers.aliquotaIpi.controller.text) ?? 0,
          quantidadeDisponivel:
              double.tryParse(
                _controllers.quantidadeDisponivel.controller.text,
              ) ??
              0,
          quantidadeReservada:
              double.tryParse(
                _controllers.quantidadeReservada.controller.text,
              ) ??
              0,
          pesoLiquido:
              double.tryParse(_controllers.pesoLiquido.controller.text) ?? 0,
          dimensaoAltura:
              double.tryParse(_controllers.dimensaoAltura.controller.text) ?? 0,
          dimensaoLargura:
              double.tryParse(_controllers.dimensaoLargura.controller.text) ??
              0,
          dimensaoProfundidade:
              double.tryParse(
                _controllers.dimensaoProfundidade.controller.text,
              ) ??
              0,
        );

    ref.read(produtoAdicionarViewModelProvider.notifier).enviarResumo();

    widget.onNext('Contato e Meta');
  }
}
