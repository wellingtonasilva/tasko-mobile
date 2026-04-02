import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_app_bar_default.dart';
import 'package:tasko_mobile/common/widgets/drawer/custom_drawer.dart';

class ModuloPlaceholderScreen extends BaseScreen {
  const ModuloPlaceholderScreen({
    super.key,
    required this.title,
    required this.menuKey,
  });

  final String title;
  final String menuKey;

  @override
  BaseScreenState<ModuloPlaceholderScreen> createState() =>
      _ModuloPlaceholderScreenState();
}

class _ModuloPlaceholderScreenState
    extends BaseScreenState<ModuloPlaceholderScreen> {
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
      case 'trocar-vendedor':
        ref.read(vendedorSelecionadoProvider.notifier).limpar();
        context.go('/selecao-vendedor');
        break;
      default:
        break;
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(onTap: _onMenuTap, currentMenu: widget.menuKey),
      appBar: CustomAppBarDefault(
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onSearchPressed: () {
          showSnackBar('Search pressed', isError: false);
        },
        onSettingsPressed: () {
          showSnackBar('Settings pressed', isError: false);
        },
      ),
      backgroundColor: kColorStylePrimary100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction, size: 48),
              const SizedBox(height: 12),
              Text(widget.title, style: kTestStyleBoldText24),
              const SizedBox(height: 8),
              Text(
                'Este módulo será implementado nas próximas etapas do roadmap.',
                textAlign: TextAlign.center,
                style: kTestStyleRegularText14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
