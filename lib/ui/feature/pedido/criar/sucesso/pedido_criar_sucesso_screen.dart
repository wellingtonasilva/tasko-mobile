import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_rascunho_view_model.dart';

class PedidoCriarSucessoScreen extends BaseScreen {
  const PedidoCriarSucessoScreen({super.key});

  @override
  BaseScreenState<PedidoCriarSucessoScreen> createState() =>
      _PedidoCriarSucessoScreenState();
}

class _PedidoCriarSucessoScreenState
    extends BaseScreenState<PedidoCriarSucessoScreen> {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 60),
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
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Pedido criado com sucesso!',
                                        style: kTestStyleBoldText24,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Seu pedido foi criado com sucesso. Você pode acessar a página principal',
                                        style: kTestStyleMediumText14.copyWith(
                                          color: kColorStyleSecondinaryLight400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    SizedBox(height: 24),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomButton(
                      label: 'Ir para o início',
                      options: CustomButtonOptions(
                        color: kColorStylePrimaryNeutralPaletteDarkDefault,
                        width: double.infinity,
                        height: 50,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                        ref
                            .read(pedidoCriarRascunhoViewModelProvider.notifier)
                            .resetFluxoCompleto();
                        context.go('/pedidos');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
