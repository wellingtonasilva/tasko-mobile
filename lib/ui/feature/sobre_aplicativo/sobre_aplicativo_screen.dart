import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';

class SobreAplicativoScreen extends BaseScreen {
  const SobreAplicativoScreen({super.key});

  @override
  BaseScreenState<SobreAplicativoScreen> createState() =>
      _SobreAplicativoScreenState();
}

class _SobreAplicativoScreenState
    extends BaseScreenState<SobreAplicativoScreen> {
  @override
  Widget buildContent(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(color: kColorStylePrimary100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sobre o Aplicativo',
                            style: kTestStyleBoldText24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: kColorStylePrimaryNeutralPaletteLightDefault,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem-vindo ao Tasko, o aplicativo de gerenciamento de tarefas que vai transformar a maneira como você organiza seu dia a dia!',
                            style: kTestStyleRegularText16,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Com o Tasko, você pode criar, organizar e acompanhar suas tarefas de forma simples e eficiente. Nossa interface intuitiva e recursos poderosos tornam o gerenciamento de tarefas uma experiência agradável e produtiva.',
                            style: kTestStyleRegularText16,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Recursos principais do Tasko:',
                            style: kTestStyleBoldText18,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '- Criação rápida de tarefas\n- Organização por categorias\n- Lembretes e notificações\n- Sincronização em nuvem\n- Interface amigável',
                            style: kTestStyleRegularText16,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Baixe o Tasko agora e comece a organizar suas tarefas de maneira mais eficiente! Estamos aqui para ajudar você a alcançar seus objetivos e tornar seu dia a dia mais produtivo.',
                            style: kTestStyleRegularText16,
                          ),
                        ],
                      ),
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
