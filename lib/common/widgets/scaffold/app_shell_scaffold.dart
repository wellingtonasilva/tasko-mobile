import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_app_bar_default.dart';
import 'package:tasko_mobile/common/widgets/drawer/custom_drawer.dart';

class AppShellScaffold extends ConsumerStatefulWidget {
  const AppShellScaffold({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  final Widget child;
  final String currentLocation;

  @override
  ConsumerState<AppShellScaffold> createState() => _AppShellScaffoldState();
}

class _AppShellScaffoldState extends ConsumerState<AppShellScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMenuTap(String menuOption) {
    Navigator.of(context).pop();

    switch (menuOption) {
      case 'home':
        context.go('/home');
        break;
      case 'vendedores':
        context.go('/vendedores');
        break;
      case 'clientes':
        context.go('/clientes');
        break;
      case 'produtos':
        context.go('/produtos');
        break;
      case 'pedidos':
        context.go('/pedidos');
        break;
      case 'agenda':
        context.go('/agenda');
        break;
      case 'metas':
        context.go('/metas');
        break;
      case 'usuarios':
        context.go('/usuarios');
        break;
      case 'trocar-vendedor':
        ref.read(vendedorSelecionadoProvider.notifier).limpar();
        context.go('/selecao-vendedor');
        break;
      default:
        break;
    }
  }

  String _menuKeyFromLocation(String location) {
    if (location.startsWith('/home')) return 'home';
    if (location.startsWith('/vendedores')) return 'vendedores';
    if (location.startsWith('/clientes')) return 'clientes';
    if (location.startsWith('/produtos')) return 'produtos';
    if (location.startsWith('/pedidos')) return 'pedidos';
    if (location.startsWith('/agenda')) return 'agenda';
    if (location.startsWith('/metas')) return 'metas';
    if (location.startsWith('/usuarios')) return 'usuarios';
    return 'home';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        onTap: _onMenuTap,
        currentMenu: _menuKeyFromLocation(widget.currentLocation),
      ),
      appBar: CustomAppBarDefault(
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onSearchPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Search pressed')));
        },
        onSettingsPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Settings pressed')));
        },
      ),
      backgroundColor: kColorStylePrimary100,
      body: widget.child,
    );
  }
}
