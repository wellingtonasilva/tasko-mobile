import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/dashboard/custom_dashboard_card_default.dart';
import 'package:tasko_mobile/ui/feature/home/home_screen_view_model.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  BaseScreenState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  bool get useScaffold => false;

  @override
  initState() {
    super.initState();

    ref.read(homeScreenViewModelProvider).lastLoginCommand.execute();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(homeScreenViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: RefreshIndicator(
        onRefresh: () async {},
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
                      child: Text(
                        ref
                            .watch(homeScreenViewModelProvider.notifier)
                            .welcomeMessage,
                        style: kTestStyleBoldText24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonPrimary(
                        label: 'Adicionar Pedido',
                        onPressed: () async {
                          final adicionado = await context.pushNamed<bool>(
                            'pedidos-criar',
                          );
                          if (adicionado == true) {
                            showSnackBar(
                              'Pedido adicionado com sucesso!',
                              isError: false,
                            );
                          }
                        },
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
                        iconBackgroundColor: kColorStyleInformationLightDefault,
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
    );
  }
}
