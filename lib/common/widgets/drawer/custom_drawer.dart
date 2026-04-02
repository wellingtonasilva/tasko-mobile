import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.onTap, this.currentMenu});

  final Function(String menuOptions) onTap;
  final String? currentMenu;

  Widget _buildMenuItem({
    required String keyName,
    required String label,
    required IconData icon,
  }) {
    return Builder(
      builder: (context) {
        return ListTile(
          leading: Icon(icon),
          title: Text(label),
          selected: currentMenu == keyName,
          onTap: () {
            onTap(keyName);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      backgroundColor: kColorStylePrimaryNeutralPaletteLightDefault,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kColorStylePrimaryNeutralPaletteLightDefault,
              // Removendo qualquer border ou sombra
              border: null,
              boxShadow: [],
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Image(
              image: AssetImage('assets/images/pos_logo.png'),
              height: 40,
            ),
          ),
          _buildMenuItem(keyName: 'home', label: 'Home', icon: Icons.home),
          _buildMenuItem(
            keyName: 'vendedores',
            label: 'Vendedores',
            icon: Icons.badge,
          ),
          _buildMenuItem(
            keyName: 'clientes',
            label: 'Clientes',
            icon: Icons.groups,
          ),
          _buildMenuItem(
            keyName: 'produtos',
            label: 'Produtos',
            icon: Icons.inventory_2,
          ),
          _buildMenuItem(
            keyName: 'pedidos',
            label: 'Pedidos',
            icon: Icons.shopping_cart,
          ),
          _buildMenuItem(
            keyName: 'agenda',
            label: 'Agenda',
            icon: Icons.calendar_month,
          ),
          _buildMenuItem(keyName: 'metas', label: 'Metas', icon: Icons.flag),
          const Divider(),
          _buildMenuItem(
            keyName: 'trocar-vendedor',
            label: 'Trocar Vendedor',
            icon: Icons.switch_account,
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'Custom Drawer')
Widget customDrawerPreview() {
  return CustomDrawer(onTap: (String menuOptions) {}, currentMenu: 'home');
}
