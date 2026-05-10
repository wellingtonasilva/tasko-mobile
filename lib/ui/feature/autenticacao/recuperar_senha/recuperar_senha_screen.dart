import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button.dart';
import 'package:tasko_mobile/common/widgets/textfield/custom_text_form_field.dart';
import 'package:tasko_mobile/domain/usuario/request/solicitacao_recuperar_senha_request.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/recuperar_senha/recuperar_senha_controllers.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/recuperar_senha/recuperar_senha_ui_state.dart';
import 'package:tasko_mobile/ui/feature/autenticacao/recuperar_senha/recuperar_senha_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class RecuperarSenhaScreen extends BaseScreen {
  const RecuperarSenhaScreen({super.key});

  @override
  BaseScreenState<RecuperarSenhaScreen> createState() =>
      _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends BaseScreenState<RecuperarSenhaScreen> {
  late final RecuperarSenhaControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = RecuperarSenhaControllers();

    final viewModel = ref.read(recuperarSenhaViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };

    viewModel.onRecuperarSenhaSucesso = () {
      if (mounted) {
        context.go('/login');
      }
    };
    viewModel.onStartEvent = () {
      if (mounted) {
        showLoading();
      }
    };
    viewModel.onFinishEvent = () {
      if (mounted) {
        hideLoading();
      }
    };
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(recuperarSenhaViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary0,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
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
                            height: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              context.go('/login');
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Form(
                          key: _controllers.formKey,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Recuperar senha',
                                  style: kTestStyleBoldText24,
                                ),
                              ),
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Vamos recuperar sua senha. Por favor, informe o e-mail associado à sua conta.',
                                  style: kTestStyleMediumText14.copyWith(
                                    color: kColorStyleSecondinaryLight400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              CustomTextFormField(
                                labelText: 'E-mail',
                                controller: _controllers.email.controller,
                                validator: _controllers.email.validator,
                                autofillHints: [AutofillHints.email],
                              ),
                              SizedBox(height: 24),
                              CustomButton(
                                label: 'Continuar',
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
                                    color:
                                        kColorStylePrimaryNeutralPaletteDark600,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  textStyle: kTestStyleBoldText16.copyWith(
                                    color:
                                        kColorStylePrimaryNeutralPaletteLightDefault,
                                  ),
                                ),
                                onPressed: () {
                                  //context.go('/login/reset-password-success');
                                  _handleRecuperarSenha(viewModel);
                                },
                              ),
                              SizedBox(height: 24),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '© 2026 WAS Sistemas. Todos os direitos reservados.',
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
      ),
    );
  }

  void _handleRecuperarSenha(RecuperarSenhaUiState viewModel) {
    if (_controllers.formKey.currentState?.validate() ?? false) {
      _controllers.formKey.currentState?.save();
    }

    final request = SolicitacaoRecuperarSenhaRequest(
      email: _controllers.email.controller.text,
    );

    ref
        .read(recuperarSenhaViewModelProvider)
        .solicitarRecuperacaoSenhaCommand
        .execute(request);
  }
}
