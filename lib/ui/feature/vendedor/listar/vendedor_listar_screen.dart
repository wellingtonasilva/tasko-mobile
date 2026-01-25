import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_app_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/dashboard/custom_dashboard_card_default.dart';
import 'package:tasko_mobile/common/widgets/list/custom_list_view.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_view_model.dart';
import 'package:tasko_mobile/ui/feature/vendedor/manter/vendedor_manter_screen.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorListarScreen extends BaseScreen {
  const VendedorListarScreen({super.key});

  @override
  BaseScreenState<VendedorListarScreen> createState() =>
      _VendedorListarScreenState();
}

class _VendedorListarScreenState extends BaseScreenState<VendedorListarScreen> {
  @override
  void initState() {
    super.initState();

    final viewModel = ref.read(vendedorListarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: kColorStyleSuccessDarkDefault,
            ),
          );
        } else if (result is Failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: kColorStyleErrorDarkDefault,
            ),
          );
        }
      }
    };
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBarDefault(
      onMenuPressed: () {
        showSnackBar('Menu pressed', isError: false);
      },
      onSearchPressed: () {
        showSnackBar('Search pressed', isError: false);
      },
      onSettingsPressed: () {
        showSnackBar('Settings pressed', isError: false);
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(vendedorListarViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            return viewModel.listarVendedoresCommand.execute();
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
                        child: Text('Vendedor', style: kTestStyleBoldText24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Vendedor',
                          onPressed: () {},
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 200),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: kColorStyleSecondinaryDark200,
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    'Lista de Vendedores',
                                    style: kTestStyleBoldText16,
                                  ),
                                  const SizedBox(height: 20),
                                  viewModel.listarVendedoresCommand.running
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : CustomListView<VendedorResponse>(
                                          values: viewModel.vendedores,
                                          onTap: (value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VendedorManterScreen(
                                                      vendedorId: value.id,
                                                    ),
                                              ),
                                            );
                                            /*
                                context.pushNamed(
                                  Routes.vendedorManter,
                                  pathParameters: {'id': value.id.toString()},
                                );
                                */
                                          },
                                          getTitle: (value) =>
                                              value.nomeVendedor,
                                          getSubtitle: (value) =>
                                              value.numeroTelefone,

                                          onDelete: (vendedor, index) {
                                            _excluirVendedor(
                                              vendedor.id,
                                              index,
                                              vendedor,
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
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

  void _excluirVendedor(
    int id,
    int indexRemovido,
    VendedorResponse vendedorRemovido,
  ) async {
    final viewModel = ref.read(vendedorListarViewModelProvider);
    // Remover o item da lista visualmente
    setState(() {
      viewModel.vendedores.removeAt(indexRemovido);
    });

    await viewModel.excluirVendedorCommand.execute(id);
    if (viewModel.excluirVendedorCommand.result is Failure) {
      setState(() {
        viewModel.vendedores.insert(indexRemovido, vendedorRemovido);
      });
    }
  }
}
