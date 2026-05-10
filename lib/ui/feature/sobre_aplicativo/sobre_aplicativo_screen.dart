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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 8),
                      Text('Sobre o aplicativo', style: kTestStyleBoldText24),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Main card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset(
                                'assets/images/pos_logo.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tasko', style: kTestStyleBoldText20),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Versão 1.0.0 (20)',
                                    style: kTestStyleRegularText14.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('O aplicativo', style: kTestStyleBoldText18),
                        const SizedBox(height: 8),
                        Text(
                          'Solução completa para gestão comercial, unindo Força de Vendas e Ponto de Venda (POS) em um único aplicativo.\n\nMais produtividade, controle e agilidade para o seu negócio.',
                          style: kTestStyleRegularText14,
                        ),
                        const SizedBox(height: 20),
                        _InfoCard(
                          icon: Icons.person,
                          iconColor: Color(0xFFFF6D00),
                          title: 'Força de Vendas',
                          description:
                              'Gestão de clientes, pedidos, metas, rotas e muito mais para sua equipe externa.',
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.point_of_sale,
                          iconColor: Color(0xFF009B4D),
                          title: 'POS (Ponto de Venda)',
                          description:
                              'Venda rápida e segura no balcão com emissão de comprovantes e diversas formas de pagamento.',
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Color(0xFFE3F0FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Color(0xFF1976D2),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Este aplicativo está em constante evolução para oferecer a melhor experiência para você e seu time.',
                                  style: kTestStyleRegularText14.copyWith(
                                    color: Color(0xFF1976D2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            '© 2026 WAS Sistemas\nTodos os direitos reservados.',
                            textAlign: TextAlign.center,
                            style: kTestStyleRegularText12.copyWith(
                              color: Colors.grey[500],
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
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kTestStyleBoldText16),
                const SizedBox(height: 4),
                Text(description, style: kTestStyleRegularText14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
