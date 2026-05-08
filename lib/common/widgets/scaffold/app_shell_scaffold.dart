import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/auth_local_storage.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_app_bar_default.dart';
import 'package:tasko_mobile/common/widgets/drawer/custom_drawer.dart';
import 'package:tasko_mobile/util/confirmation_dialog_util.dart';

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
        context.go('/vendedor-metas/1');
        break;
      case 'usuarios':
        context.go('/usuarios');
        break;
      case 'configuracoes':
        context.go('/configuracoes');
        break;
      case 'trocar-usuario':
        ConfirmationDialogUtil().showConfirmationDialog(
          context: context,
          title: 'Sair',
          message: 'Tem certeza que deseja sair do aplicativo?',
          confirmLabel: 'Sair',
          cancelLabel: 'Cancelar',
          onConfirm: () {
            ref.read(authLocalStorageProvider).clear();
            context.go('/login');
          },
        );
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
    if (location.startsWith('/configuracoes')) return 'configuracoes';
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
