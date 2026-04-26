import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_text_form_field.dart';

class RegisterV3SmartphoneScreen extends StatelessWidget {
  const RegisterV3SmartphoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStyleSecondinaryDark900,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 24),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'assets/images/pos_logo.png',
                          height: 34,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Cadastrar',
                              style: kTestStyleBoldText32,
                            ),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Vamos criar uma nova conta',
                              style: kTestStyleMediumText14.copyWith(
                                color: kColorStyleSecondinaryLight400,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          CustomTextFormField(
                            labelText: 'Your name',
                            autofillHints: [AutofillHints.name],
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            labelText: 'E-mail',
                            autofillHints: [AutofillHints.email],
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            labelText: 'Phone Number',
                            autofillHints: [AutofillHints.telephoneNumber],
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            labelText: 'Password',
                            autofillHints: [AutofillHints.password],
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            labelText: 'Repeat Password',
                            autofillHints: [AutofillHints.password],
                          ),
                          SizedBox(height: 24),
                          CustomButton(
                            label: 'Cadastrar',
                            options: CustomButtonOptions(
                              color:
                                  kColorStylePrimaryNeutralPaletteDarkDefault,
                              width: double.infinity,
                              height: 50,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                24,
                                0,
                                24,
                                0,
                              ),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0,
                                0,
                                0,
                                0,
                              ),
                              elevation: 3,
                              borderSide: BorderSide(
                                color: kColorStylePrimaryNeutralPaletteDark600,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              textStyle: kTestStyleBoldText16.copyWith(
                                color:
                                    kColorStylePrimaryNeutralPaletteLightDefault,
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Não foi possível salvar as informações.',
                                    style: kTestStyleBoldText14.copyWith(
                                      color: kColorStyleInformationDark600,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 4000),
                                  backgroundColor:
                                      kColorStyleInformationLightDefault,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Já tem uma conta? ',
                                    style: kTestStyleMediumText14.copyWith(
                                      color: kColorStyleSecondinaryLight400,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Entrar',
                                style: kTestStyleBoldText14.copyWith(
                                  color: kColorStyleInformationDarkDefault,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  '© 2026 WAS Sistemas. All rights reserved.',
                                  style: kTestStyleMediumText14.copyWith(
                                    color: kColorStyleSecondinaryLight400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Termos & Condições',
                                style: kTestStyleBoldText14.copyWith(
                                  color: kColorStyleInformationDarkDefault,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: kColorStyleSecondinaryLight400,
                                  width: 1,
                                  height: 15,
                                  child: SizedBox(height: 10),
                                ),
                              ),
                              Text(
                                'Política de Privacidade',
                                style: kTestStyleBoldText14.copyWith(
                                  color: kColorStyleInformationDarkDefault,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    Image.asset('assets/images/pos_login_v3_tablet_left.png'),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Unleash the Power of Our Intuitive Point of Sale Solution',
                                  style: kTestStyleBoldText24.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Experience the future of retail with our user-friendly POS platform. Increase your sales, streamline operations, and delight your customers with a modern and efficient checkout process',
                                  style: kTestStyleRegularText14.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
