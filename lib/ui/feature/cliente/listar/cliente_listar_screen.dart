import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/list/custom_list_view.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/ui/feature/cliente/listar/cliente_listar_view_model.dart';
import 'package:tasko_mobile/util/result.dart';

class ClienteListarScreen extends BaseScreen {
  const ClienteListarScreen({super.key});

  @override
  BaseScreenState<ClienteListarScreen> createState() =>
      _ClienteListarScreenState();
}

class _ClienteListarScreenState extends BaseScreenState<ClienteListarScreen> {
  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(clienteListarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) {
        return;
      }

      if (result is Success) {
        showSnackBar(message, isError: false);
      } else {
        showSnackBar(message, isError: true);
      }
    };
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(clienteListarViewModelProvider);

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
                                  'Lista de Clientes',
                                  style: kTestStyleBoldText16,
                                ),
                                const SizedBox(height: 20),
                                viewModel.listarClientesCommand.running
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CustomListView<ClienteResponse>(
                                        values: viewModel.clientes,
                                        onTap: (value) {
                                          context.pushNamed(
                                            'clientes-manter',
                                            pathParameters: {
                                              'id': value.id.toString(),
                                            },
                                          );
                                        },
                                        getTitle: (value) => value.razaoSocial,
                                        getSubtitle: (value) =>
                                            value.nomeFantasia ?? '-',
                                        getSubtitle1: (value) =>
                                            value.cnpjCpf ?? '-',
                                        getSubtitle2: (value) =>
                                            '${value.cidade ?? '-'} - ${value.estado ?? '-'}',
                                        onDelete: (cliente, index) {
                                          _excluirCliente(
                                            cliente.id,
                                            index,
                                            cliente,
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
}
