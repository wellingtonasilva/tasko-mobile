import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/card/custom_simple_item_list_card.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/ui/feature/cliente/listar/cliente_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/cliente/listar/cliente_listar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteListarScreen extends BaseScreen {
  const ClienteListarScreen({super.key});

  @override
  BaseScreenState<ClienteListarScreen> createState() =>
      _ClienteListarScreenState();
}

class _ClienteListarScreenState extends BaseScreenState<ClienteListarScreen> {
  late final ClienteListarControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = ClienteListarControllers();
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
    final viewModel = ref.watch(clienteListarViewModelProvider);
    final clientesFiltrados = _filtrarClientes(viewModel.clientes ?? []);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await viewModel.listarClientesCommand.execute();
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
                      child: Text('Clientes', style: kTestStyleBoldText24),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonPrimary(
                        label: 'Adicionar Cliente',
                        onPressed: () async {
                          final adicionado = await context.pushNamed<bool>(
                            'clientes-adicionar',
                          );
                          if (adicionado == true) {
                            showSnackBar('Cliente adicionado com sucesso!');
                            await ref
                                .read(clienteListarViewModelProvider)
                                .listarClientesCommand
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
                    //Listaagem
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          viewModel.listarClientesCommand.running
                              ? const Center(child: CircularProgressIndicator())
                              : clientesFiltrados.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _controllers.pesquisar.controller.text
                                              .trim()
                                              .isEmpty
                                          ? 'Nenhum cliente encontrado.'
                                          : 'Nenhum cliente encontrado para a pesquisa.',
                                      style: kTestStyleRegularText14,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: clientesFiltrados.length,
                                  itemBuilder: (context, index) {
                                    final cliente = clientesFiltrados[index];
                                    return CustomSimpleItemListCard(
                                      title: cliente.razaoSocial ?? '',
                                      subtitle: 'ID: ${cliente.id}',
                                      onTap: _onCustomSimpleItemListCardTap,
                                      id: cliente.id,
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
    );
  }

  void _excluirCliente(
    int id,
    int indexRemovido,
    ClienteResponse clienteRemovido,
  ) async {
    final viewModel = ref.read(clienteListarViewModelProvider);

    setState(() {
      viewModel.clientes.removeAt(indexRemovido);
    });

    await viewModel.excluirClienteCommand.execute(id);
    final result = viewModel.excluirClienteCommand.result;

    if (result is Failure && mounted) {
      setState(() {
        viewModel.clientes.insert(indexRemovido, clienteRemovido);
      });
    }
  }

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onCustomSimpleItemListCardTap(int id) async {
    final atualizado = await context.pushNamed<bool>(
      'clientes-manter',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Cliente atualizado com sucesso!');
      ref.read(clienteListarViewModelProvider).listarClientesCommand.execute();
    }
  }

  List<ClienteResponse> _filtrarClientes(List<ClienteResponse> clientes) {
    final pesquisa = _controllers.pesquisar.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return clientes;
    }

    return clientes.where((cliente) {
      final nome = cliente.razaoSocial?.toLowerCase() ?? '';

      return nome.contains(pesquisa);
    }).toList();
  }
}
