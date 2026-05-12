import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/pedido_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/pedido_listar_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/widgets/custom_pedido_item_list_card.dart';
import 'package:tasko_mobile/ui/feature/pedido/listar/widgets/pedido_item_status_helper.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoListarScreen extends BaseScreen {
  const PedidoListarScreen({super.key});

  @override
  BaseScreenState<PedidoListarScreen> createState() =>
      _PedidoListarScreenState();
}

class _PedidoListarScreenState extends BaseScreenState<PedidoListarScreen> {
  late final PedidoListarControllers _controllers;

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

    _controllers = PedidoListarControllers();
    _controllers.pesquisar.controller.addListener(_onPesquisarChanged);
  }

  @override
  void dispose() {
    _controllers.pesquisar.controller.removeListener(_onPesquisarChanged);
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(pedidoListarViewModelProvider);
    final pedidosFiltrados = _filtrarPedidos(viewModel.pedidos);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: RefreshIndicator(
        onRefresh: () async {
          debugPrint('Refresh triggered');
          await viewModel.listarPedidosCommand.execute();
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
                      child: buildTextField(
                        _controllers.pesquisar,
                        isShowHint: true,
                        topPadding: 0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Listaagem
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              viewModel.listarPedidosCommand.running
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : pedidosFiltrados.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 24.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          _controllers.pesquisar.controller.text
                                                  .trim()
                                                  .isEmpty
                                              ? 'Nenhum pedido encontrado.'
                                              : 'Nenhum pedido encontrado para a pesquisa.',
                                          style: kTestStyleRegularText14,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: pedidosFiltrados.length,
                                      itemBuilder: (context, index) {
                                        final pedido = pedidosFiltrados[index];
                                        return CustomPedidoItemListCard(
                                          pedido: pedido,
                                          status:
                                              PedidoItemStatusHelper.getStatus(
                                                pedido: pedido,
                                              ),
                                          onTap: _onCustomSimpleItemListCardTap,
                                        );
                                      },
                                    ),
                            ],
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
    );
  }

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onCustomSimpleItemListCardTap(int id) async {
    final atualizado = await context.pushNamed<bool>(
      'pedidos-detalhe',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Pedido atualizado com sucesso!');
      ref.read(pedidoListarViewModelProvider).listarPedidosCommand.execute();
    }
  }

  List<PedidoResponse> _filtrarPedidos(List<PedidoResponse> pedidos) {
    final pesquisa = _controllers.pesquisar.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return pedidos;
    }

    return pedidos.where((pedido) {
      final id = pedido.id.toString().toLowerCase();
      final nomeCliente = pedido.nomeFantasiaCliente?.toLowerCase() ?? '';
      final nomeVendedor = pedido.nomeVendedor?.toLowerCase() ?? '';

      return id.contains(pesquisa) ||
          nomeCliente.contains(pesquisa) ||
          nomeVendedor.contains(pesquisa);
    }).toList();
  }
}
