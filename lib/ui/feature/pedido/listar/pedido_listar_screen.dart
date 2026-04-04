import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/list/custom_list_view.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/pedido_listar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoListarScreen extends BaseScreen {
  const PedidoListarScreen({super.key});

  @override
  BaseScreenState<PedidoListarScreen> createState() =>
      _PedidoListarScreenState();
}

class _PedidoListarScreenState extends BaseScreenState<PedidoListarScreen> {
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(pedidoListarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) return;
      if (result is Success) {
        showSnackBar(message, isError: false);
      } else {
        showSnackBar(message, isError: true);
      }
    };
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(pedidoListarViewModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await viewModel.listarPedidosCommand.execute();
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
                      child: Text('Pedidos', style: kTestStyleBoldText24),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonPrimary(
                        label: 'Novo Pedido',
                        onPressed: () async {
                          final adicionado = await context.pushNamed<bool>(
                            'pedidos-criar',
                          );
                          if (adicionado == true) {
                            await ref
                                .read(pedidoListarViewModelProvider)
                                .listarPedidosCommand
                                .execute();
                          }
                        },
                        trailingIcon: Icons.add,
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
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lista de Pedidos',
                                  style: kTestStyleBoldText16,
                                ),
                                const SizedBox(height: 20),
                                viewModel.listarPedidosCommand.running
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CustomListView<PedidoResponse>(
                                        values: viewModel.pedidos,
                                        onTap: (value) {
                                          context.pushNamed(
                                            'pedidos-detalhe',
                                            pathParameters: {
                                              'id': value.id.toString(),
                                            },
                                          );
                                        },
                                        getTitle: (value) =>
                                            value.numeroPedido ??
                                            'Pedido #${value.id}',
                                        getSubtitle: (value) =>
                                            _formatDate(value.dataPedido),
                                        getSubtitle1: (value) =>
                                            value.pedidoStatusTipoNome ?? '-',
                                        getSubtitle2: (value) =>
                                            'R\$ ${value.valorTotal.toStringAsFixed(2)}',
                                        onDelete: (pedido, index) {
                                          _excluirPedido(
                                            pedido.id,
                                            index,
                                            pedido,
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
    );
  }

  void _excluirPedido(
    int id,
    int indexRemovido,
    PedidoResponse pedidoRemovido,
  ) async {
    final viewModel = ref.read(pedidoListarViewModelProvider);

    setState(() {
      viewModel.pedidos.removeAt(indexRemovido);
    });

    await viewModel.excluirPedidoCommand.execute(id);
    final result = viewModel.excluirPedidoCommand.result;

    if (result is Failure && mounted) {
      setState(() {
        viewModel.pedidos.insert(indexRemovido, pedidoRemovido);
      });
    }
  }
}
