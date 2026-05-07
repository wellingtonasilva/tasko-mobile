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
          selectedColor: kColorStylePrimaryNeutralPaletteLight200,
          selectedTileColor: kColorStylePrimaryNeutralPaletteLight100,
          leading: Icon(
            icon,
            color: currentMenu == keyName
                ? kColorStylePrimaryNeutralPaletteDarkDefault
                : null,
            size: 20,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: currentMenu == keyName
                  ? kColorStylePrimaryNeutralPaletteDarkDefault
                  : null,
            ),
          ),
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
          Divider(
            color: Colors.grey.withOpacity(0.15),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          _buildMenuItem(
            keyName: 'pedidos',
            label: 'Pedidos',
            icon: Icons.shopping_cart,
          ),
          _buildMenuItem(
            keyName: 'clientes',
            label: 'Clientes',
            icon: Icons.groups,
          ),
          _buildMenuItem(
            keyName: 'agenda',
            label: 'Agenda',
            icon: Icons.calendar_month,
          ),
          _buildMenuItem(keyName: 'metas', label: 'Metas', icon: Icons.flag),
          Divider(
            color: Colors.grey.withOpacity(0.15),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),

          _buildMenuItem(
            keyName: 'produtos',
            label: 'Produtos',
            icon: Icons.inventory_2,
          ),
          _buildMenuItem(
            keyName: 'vendedores',
            label: 'Vendedores',
            icon: Icons.badge,
          ),
          Divider(
            color: Colors.grey.withOpacity(0.15),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          _buildMenuItem(
            keyName: 'usuarios',
            label: 'Usuários',
            icon: Icons.person,
          ),
          _buildMenuItem(
            keyName: 'configuracoes',
            label: 'Configurações',
            icon: Icons.settings,
          ),
          Divider(
            color: Colors.grey.withOpacity(0.15),
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          _buildMenuItem(
            keyName: 'trocar-usuario',
            label: 'Sair',
            icon: Icons.logout_outlined,
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
