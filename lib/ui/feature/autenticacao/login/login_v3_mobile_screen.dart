import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_text_form_field.dart';

class LoginV3MobileScreen extends StatelessWidget {
  const LoginV3MobileScreen({super.key});

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
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'assets/images/pos_logo.png',
                          height: 50,
                        ),
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Login', style: kTestStyleBoldText32),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Vamos fazer login na sua conta primeiro',
                          style: kTestStyleMediumText14.copyWith(
                            color: kColorStyleSecondinaryLight400,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      CustomTextFormField(
                        labelText: 'Usuário ou Email',
                        autofillHints: [AutofillHints.email],
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        labelText: 'Senha',
                        autofillHints: [AutofillHints.password],
                      ),
                      SizedBox(height: 22),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (value) {}),
                              Text(
                                'Lembrar-me',
                                style: kTestStyleMediumText14.copyWith(
                                  color: kColorStyleSecondinaryLight400,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pushNamed<bool>('criar-password');
                            },
                            child: Text(
                              'Esqueceu a senha?',
                              style: kTestStyleBoldText14.copyWith(
                                color: kColorStyleInformationDarkDefault,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      CustomButton(
                        label: 'Login',
                        options: CustomButtonOptions(
                          color: kColorStylePrimaryNeutralPaletteDarkDefault,
                          width: double.infinity,
                          height: 50,
                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
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
                            color: kColorStylePrimaryNeutralPaletteLightDefault,
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
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey, // Cor da linha
                              thickness: 0.5, // Espessura da linha
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "or",
                              style: kTestStyleMediumText16.copyWith(
                                color: kColorStyleSecondinaryLight400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.grey, thickness: 0.5),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      CustomButton(
                        label: 'Login with Google',
                        iconImage: Image.asset(
                          'assets/images/pos_logo_google.png',
                          height: 24,
                        ),
                        options: CustomButtonOptions(
                          width: double.infinity,
                          height: 50,
                          color: Colors.white,
                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                            0,
                            0,
                            0,
                            0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: kColorStyleSecondinaryLight200,
                            width: 0.8,
                          ),
                          textStyle: kTestStyleBoldText16.copyWith(
                            color: kColorStyleSecondinaryDarkDefault,
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
                                'Não tem uma conta? ',
                                style: kTestStyleMediumText14.copyWith(
                                  color: kColorStyleSecondinaryLight400,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the register screen
                              context.go('/login/criar-conta');
                            },
                            child: Text(
                              'Cadastre-se aqui',
                              style: kTestStyleBoldText14.copyWith(
                                color: kColorStyleInformationDarkDefault,
                              ),
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
                                  'Desperte o poder da nossa solução intuitiva de ponto de venda',
                                  style: kTestStyleBoldText24.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Experimente o futuro do varejo com nossa plataforma de PDV amigável. Aumente suas vendas, otimize operações e encante seus clientes com um processo de checkout moderno e eficiente',
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
