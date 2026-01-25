import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_app_bar_default.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
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
        backgroundColor: kColorStylePrimaryNeutralPaletteLightDefault,
        body: Center(
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Conteúdo da tela de listar vendedor',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(vendedorListarViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimaryNeutralPaletteLightDefault,
        body: RefreshIndicator(
          onRefresh: () async {
            return viewModel.listarVendedoresCommand.execute();
          },
          child: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Divider(
                  height: 1,
                  thickness: .9,
                  color: kColorStyleSecondinaryLight300,
                ),
                Expanded(
                  child: viewModel.listarVendedoresCommand.running
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: CustomListView<VendedorResponse>(
                            values: viewModel.vendedores,
                            onTap: (value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendedorManterScreen(
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
                            getTitle: (value) => value.nomeVendedor,
                            getSubtitle: (value) => value.numeroTelefone,

                            onDelete: (vendedor, index) {
                              _excluirVendedor(vendedor.id, index, vendedor);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: kColorStylePrimaryNeutralPaletteLightDefault,
          title: Text('Vendedores (${viewModel.vendedores.length})'),
          actions: [
            IconButton(
              onPressed: () {
                //context.pushNamed(Routes.vendedorAdicionar);
              },
              icon: Icon(Icons.add_circle_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
  */

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
