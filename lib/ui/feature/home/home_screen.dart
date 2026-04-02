import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_app_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/dashboard/custom_dashboard_card_default.dart';
import 'package:tasko_mobile/common/widgets/drawer/custom_drawer.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  BaseScreenState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
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
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildContent(BuildContext context) {
    final vendedor = ref.watch(vendedorSelecionadoProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(onTap: _onMenuTap, currentMenu: 'home'),
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
        body: RefreshIndicator(
          onRefresh: () async {
            // Implementar lógica de refresh, se necessário
          },
          child: SingleChildScrollView(
            child: Center(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Bem-vindo', style: kTestStyleBoldText24),
                      ),
                      if (vendedor != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Vendedor ativo: ${vendedor.nomeVendedor}',
                            style: kTestStyleRegularText14,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Pedido',
                          onPressed: () async {},
                          trailingIcon: Icons.add,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Total Sales',
                          value: '\$121,412',
                          icon: Image.asset(
                            'assets/images/pos_icon_moneys.png',
                            color: kColorStylePrimaryNeutralPaletteDark500,
                            width: 35,
                          ),
                          iconBackgroundColor:
                              kColorStylePrimaryNeutralPaletteLight100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Purchase Invoice',
                          value: '543',
                          icon: Image.asset(
                            'assets/images/pos_icon_document_text.png',
                            color: kColorStyleInformationDarkDefault,
                            width: 35,
                          ),
                          iconBackgroundColor:
                              kColorStyleInformationLightDefault,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Total Tip',
                          value: '\$1,412',
                          icon: Image.asset(
                            'assets/images/pos_icon_money_tick.png',
                            color: kColorStyleSuccessDark500,
                            width: 35,
                          ),
                          iconBackgroundColor: kColorStyleSuccessLightefault,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
