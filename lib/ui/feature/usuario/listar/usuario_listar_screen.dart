import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/dashboard/custom_dashboard_card_default.dart';
import 'package:tasko_mobile/common/widgets/list/custom_list_view.dart';
import 'package:tasko_mobile/domain/usuario/response/usuario_response.dart';
import 'package:tasko_mobile/ui/feature/usuario/listar/usuario_listar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class UsuarioListarScreen extends BaseScreen {
  const UsuarioListarScreen({super.key});

  @override
  BaseScreenState<UsuarioListarScreen> createState() =>
      _UsuarioListarScreenState();
}

class _UsuarioListarScreenState extends BaseScreenState<UsuarioListarScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(usuarioListarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) return;
      if (result is Success) {
        showSnackBar(message, isError: false);
      } else {
        showSnackBar(message, isError: true);
      }
    };

    ref.read(usuarioListarViewModelProvider).listarUsuariosCommand.execute();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(usuarioListarViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.listarUsuariosCommand.execute();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                        child: Text('Usuários', style: kTestStyleBoldText24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Usuário',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'usuarios-adicionar',
                            );
                            if (adicionado == true) {
                              ref
                                  .read(usuarioListarViewModelProvider)
                                  .listarUsuariosCommand
                                  .execute();
                            }
                          },
                          trailingIcon: Icons.add,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Total Usuários',
                          value: '10',
                          icon: Image.asset(
                            'assets/images/pos_icon_box.png',
                            //color: kColorStylePrimaryNeutralPaletteDark500,
                            width: 35,
                          ),
                          iconBackgroundColor:
                              kColorStylePrimaryNeutralPaletteLight100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Usuários Ativos',
                          value: '12',
                          icon: Image.asset(
                            'assets/images/pos_icon_document_text.png',
                            //color: kColorStyleInformationDarkDefault,
                            width: 35,
                          ),
                          iconBackgroundColor:
                              kColorStyleInformationLightDefault,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDashboardCardDefault(
                          title: 'Template Mensal',
                          value: 'R\$ 1.412',
                          icon: Image.asset(
                            'assets/images/pos_icon_money_tick.png',
                            //color: kColorStyleSuccessDark500,
                            width: 35,
                          ),
                          iconBackgroundColor: kColorStyleSuccessLightefault,
                        ),
                      ),
                      //Lista de Usuários
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
                                    'Lista de Produtos',
                                    style: kTestStyleBoldText16,
                                  ),
                                  const SizedBox(height: 20),
                                  viewModel.listarUsuariosCommand.running
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : CustomListView<UsuarioResponse>(
                                          values: viewModel.usuarios,
                                          onTap: (value) {
                                            context.pushNamed(
                                              'usuarios-manter',
                                              pathParameters: {
                                                'id': value.id.toString(),
                                              },
                                            );
                                          },
                                          getTitle: (value) =>
                                              value.nomeUsuario,
                                          getSubtitle: (value) =>
                                              value.vendedor?.nomeVendedor ??
                                              '-',

                                          onDelete: (usuario, index) {
                                            _excluirUsuario(
                                              usuario.id,
                                              index,
                                              usuario,
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

  void _excluirUsuario(int id, int index, UsuarioResponse usuario) {}
}
