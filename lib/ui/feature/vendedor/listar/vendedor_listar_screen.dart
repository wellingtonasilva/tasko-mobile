import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/vendedor_listar_view_model.dart';
import 'package:tasko_mobile/ui/feature/vendedor/listar/widgets/vendedor_list_card.dart';
import 'package:tasko_mobile/util/result.dart';

class VendedorListarScreen extends BaseScreen {
  const VendedorListarScreen({super.key});

  @override
  BaseScreenState<VendedorListarScreen> createState() =>
      _VendedorListarScreenState();
}

class _VendedorListarScreenState extends BaseScreenState<VendedorListarScreen> {
  late final VendedorListarControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = VendedorListarControllers();
    _controllers.pesquisarVendedor.controller.addListener(_onPesquisarChanged);

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
  void dispose() {
    _controllers.pesquisarVendedor.controller.removeListener(
      _onPesquisarChanged,
    );
    _controllers.dispose();
    super.dispose();
  }

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(vendedorListarViewModelProvider);
    final vendedoresFiltrados = _filtrarVendedores(viewModel.vendedores);

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
                        child: Text('Vendedores', style: kTestStyleBoldText24),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Vendedor',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'vendedores-adicionar',
                            );
                            if (adicionado == true) {
                              showSnackBar('Vendedor adicionado com sucesso!');
                              ref
                                  .read(vendedorListarViewModelProvider)
                                  .listarVendedoresCommand
                                  .execute();
                            }
                          },
                          trailingIcon: Icons.add,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildTextField(
                          _controllers.pesquisarVendedor,
                          isShowHint: true,
                          topPadding: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            viewModel.listarVendedoresCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : vendedoresFiltrados.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers
                                                .pesquisarVendedor
                                                .controller
                                                .text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhum vendedor encontrado.'
                                            : 'Nenhum vendedor encontrado para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: vendedoresFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final vendedor =
                                          vendedoresFiltrados[index];
                                      return VendedorListCard(
                                        vendedor: vendedor,
                                        onTap: () async {
                                          final atualizado = await context
                                              .pushNamed<bool>(
                                                'vendedores-manter',
                                                pathParameters: {
                                                  'id': vendedor.id.toString(),
                                                },
                                              );
                                          if (atualizado == true) {
                                            showSnackBar(
                                              'Vendedor atualizado com sucesso!',
                                            );
                                            ref
                                                .read(
                                                  vendedorListarViewModelProvider,
                                                )
                                                .listarVendedoresCommand
                                                .execute();
                                          }
                                        },
                                      );
                                    },
                                  ),
                          ],
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

  List<VendedorResponse> _filtrarVendedores(List<VendedorResponse> vendedores) {
    final pesquisa = _controllers.pesquisarVendedor.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return vendedores;
    }

    return vendedores.where((vendedor) {
      final nome = vendedor.nomeVendedor?.toLowerCase() ?? '';
      final codigo = vendedor.codigoVendedor?.toLowerCase() ?? '';
      final email = vendedor.email?.toLowerCase() ?? '';
      final telefone = vendedor.numeroTelefone?.toLowerCase() ?? '';

      return nome.contains(pesquisa) ||
          codigo.contains(pesquisa) ||
          email.contains(pesquisa) ||
          telefone.contains(pesquisa);
    }).toList();
  }
}
