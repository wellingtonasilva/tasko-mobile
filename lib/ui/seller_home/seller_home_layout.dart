import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/dashboard/custom_dashboard_card_default.dart';

class SellerHomeLayout extends StatelessWidget {
  const SellerHomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SellerHeroHeader(),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButtonPrimary(
                  label: 'Novo Pedido',
                  onPressed: () {},
                  trailingIcon: Icons.add,
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Atalhos rápidos', style: kTestStyleBoldText16),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Expanded(
                      child: _QuickActionTile(
                        label: 'Clientes',
                        icon: Icons.people_alt_outlined,
                        background: kColorStyleInformationLightDefault,
                        foreground: kColorStyleInformationDarkDefault,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionTile(
                        label: 'Produtos',
                        icon: Icons.inventory_2_outlined,
                        background: kColorStyleWarningLightDefault,
                        foreground: kColorStyleWarningDark600,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionTile(
                        label: 'Pedidos',
                        icon: Icons.receipt_long_outlined,
                        background: kColorStylePrimaryNeutralPaletteLight100,
                        foreground: kColorStylePrimaryNeutralPaletteDark500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Desempenho do mês', style: kTestStyleBoldText16),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CustomDashboardCardDefault(
                      title: 'Pedidos no mês',
                      value: '128',
                      icon: Image.asset(
                        'assets/images/pos_icon_document_text.png',
                        color: kColorStyleInformationDarkDefault,
                        width: 35,
                      ),
                      iconBackgroundColor: kColorStyleInformationLightDefault,
                    ),
                    const SizedBox(height: 12),
                    CustomDashboardCardDefault(
                      title: 'Faturamento no mês',
                      value: 'R\$ 84,300',
                      icon: Image.asset(
                        'assets/images/pos_icon_moneys.png',
                        color: kColorStylePrimaryNeutralPaletteDark500,
                        width: 35,
                      ),
                      iconBackgroundColor:
                          kColorStylePrimaryNeutralPaletteLight100,
                    ),
                    const SizedBox(height: 12),
                    CustomDashboardCardDefault(
                      title: 'Comissão acumulada',
                      value: 'R\$ 2,140',
                      icon: Image.asset(
                        'assets/images/pos_icon_money_tick.png',
                        color: kColorStyleSuccessDark500,
                        width: 35,
                      ),
                      iconBackgroundColor: kColorStyleSuccessLightefault,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SellerHeroHeader extends StatelessWidget {
  const _SellerHeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            kColorStylePrimaryNeutralPaletteLight200,
            kColorStylePrimaryNeutralPaletteLightDefault,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Bem-vindo, Vendedor 1',
                  style: kTestStyleBoldText24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kColorStylePrimary0,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.today_outlined,
                      size: 16,
                      color: kColorStyleSecondinaryDark400,
                    ),
                    SizedBox(width: 6),
                    Text('Meta do dia', style: kTestStyleMediumText12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Faltam R\$ 1,200 para bater sua meta',
            style: kTestStyleRegularText14.copyWith(
              color: kColorStyleSecondinaryDark400,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.62,
              minHeight: 8,
              backgroundColor: kColorStylePrimaryNeutralPaletteLight100,
              valueColor: const AlwaysStoppedAnimation<Color>(
                kColorStylePrimaryNeutralPaletteDark500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatChip(
                label: 'Pedidos hoje',
                value: '8',
                color: kColorStyleInformationDarkDefault,
              ),
              const SizedBox(width: 10),
              _StatChip(
                label: 'Ticket médio',
                value: 'R\$ 410',
                color: kColorStyleSuccessDark500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  const _QuickActionTile({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: background.withOpacity(0.7)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: foreground, size: 24),
          const SizedBox(height: 8),
          Text(label, style: kTestStyleMediumText12),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kColorStylePrimary0,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kColorStyleSecondinaryDark200),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: kTestStyleRegularText12),
          const SizedBox(width: 6),
          Text(value, style: kTestStyleBoldText12),
        ],
      ),
    );
  }
}
