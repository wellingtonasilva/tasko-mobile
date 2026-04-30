import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button.dart';

class CriarContaSucessoScreen extends StatelessWidget {
  const CriarContaSucessoScreen({super.key});

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
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/pos_success.png',
                        width: 104,
                        height: 104,
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Conta criada com sucesso',
                              style: kTestStyleBoldText24,
                            ),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Sua conta foi criada com sucesso. Você pode acessar a página principal',
                              style: kTestStyleMediumText14.copyWith(
                                color: kColorStyleSecondinaryLight400,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          CustomButton(
                            label: 'Ir para o início',
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
                              context.go('/login');
                            },
                          ),
                          SizedBox(height: 24),
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
