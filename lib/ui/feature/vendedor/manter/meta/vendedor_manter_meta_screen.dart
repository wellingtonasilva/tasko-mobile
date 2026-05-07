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
import 'package:tasko_mobile/ui/feature/vendedor/manter/meta/vendedor_manter_meta_controllers.dart';

class VendedorManterMetaScreen extends BaseScreen {
  final Function(String value) onPrevious;
  final Function(String value) onNext;

  const VendedorManterMetaScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<VendedorManterMetaScreen> createState() =>
      _VendedorManterMetaScreenState();
}

class _VendedorManterMetaScreenState
    extends BaseScreenState<VendedorManterMetaScreen> {
  late final VendedorManterMetaControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = VendedorManterMetaControllers();
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
                          title: 'Manter Vendedor',
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
                                        active: false,
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
                                            Center(
                                              child: Icon(
                                                Icons.phone,
                                                color:
                                                    kColorStylePrimaryNeutralPaletteDarkDefault,
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'Contato',
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
                                      'Como podemos entrar em contato com o vendedor.',
                                      style: kTestStyleRegularText12.copyWith(
                                        color: kColorStyleSecondinaryDark400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.email,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.numeroTelefone,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.numeroTelefoneAlternativo,
                                  isMandatory: true,
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
                                            Center(
                                              child: Icon(
                                                Icons.radar,
                                                color:
                                                    kColorStylePrimaryNeutralPaletteDarkDefault,
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'Meta e Comissão',
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
                                      'Defina a meta mensal e o percentual de comissão do vendedor.',
                                      style: kTestStyleRegularText12.copyWith(
                                        color: kColorStyleSecondinaryDark400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.valorMetaMensal,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 10),
                                buildTextField(
                                  _controllers.percentualComissao,
                                  isMandatory: true,
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
                                widget.onPrevious('Dados Básicos');
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Próximo',
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
}
