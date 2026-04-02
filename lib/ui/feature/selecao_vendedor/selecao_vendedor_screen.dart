import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/core/vendedor_sessao_provider.dart';
import 'package:tasko_mobile/common/widgets/list/custom_list_item.dart';
import 'package:tasko_mobile/ui/feature/selecao_vendedor/selecao_vendedor_view_model.dart';

class SelecaoVendedorScreen extends BaseScreen {
  const SelecaoVendedorScreen({super.key});

  @override
  BaseScreenState<SelecaoVendedorScreen> createState() =>
      _SelecaoVendedorScreenState();
}

class _SelecaoVendedorScreenState
    extends BaseScreenState<SelecaoVendedorScreen> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Selecionar Vendedor'),
      backgroundColor: kColorStylePrimaryNeutralPaletteDark500,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(selecaoVendedorViewModelProvider);
    final selectedVendedorId = ref.watch(vendedorSelecionadoIdProvider);

    if (viewModel.carregarVendedoresCommand.running &&
        viewModel.vendedores.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.carregarVendedoresCommand.execute();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Escolha o vendedor ativo', style: kTestStyleBoldText24),
          const SizedBox(height: 8),
          Text(
            'Essa seleção será usada como contexto inicial da aplicação.',
            style: kTestStyleRegularText14,
          ),
          const SizedBox(height: 16),
          if (viewModel.vendedores.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Nenhum vendedor disponível.'),
            ),
          ...viewModel.vendedores.map(
            (vendedor) => Card(
              color: selectedVendedorId == vendedor.id
                  ? kColorStyleInformationLightDefault
                  : Colors.white,
              child: CustomListItem(
                title: vendedor.nomeVendedor,
                subtitle: 'Código: ${vendedor.codigoVendedor}',
                subtitle1: vendedor.email,
                subtitle2: vendedor.numeroTelefone,
                onTap: () {
                  ref
                      .read(selecaoVendedorViewModelProvider.notifier)
                      .selecionarVendedor(vendedor);
                  context.go('/vendedores');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
