import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.onTap});

  final Function(String menuOptions) onTap;

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
          ListTile(
            title: const Text('Opcao1'),
            onTap: () {
              onTap('opcao1');
            },
          ),
          ListTile(
            title: const Text('Opcao2'),
            onTap: () {
              onTap('opcao2');
            },
          ),
          ListTile(
            title: const Text('Opcao3'),
            onTap: () {
              onTap('opcao3');
            },
          ),
          ListTile(
            title: const Text('Opcao4'),
            onTap: () {
              onTap('opcao4');
            },
          ),
          ListTile(
            title: const Text('Opcao5'),
            onTap: () {
              onTap('opcao5');
            },
          ),

          ListTile(
            title: const Text('Opcao6'),
            onTap: () {
              onTap('opcao6');
            },
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'Custom Drawer')
Widget customDrawerPreview() {
  return CustomDrawer(onTap: (String menuOptions) {});
}
