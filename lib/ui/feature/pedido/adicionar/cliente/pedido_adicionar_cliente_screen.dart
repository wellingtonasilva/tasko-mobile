import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/auth_persistence.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/cliente/pedido_adicionar_cliente_controllers.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pedido_adicionar_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/cliente/widgets/cliente_card.dart';

class PedidoAdicionarClienteScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoAdicionarClienteScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<PedidoAdicionarClienteScreen> createState() =>
      _PedidoAdicionarClienteScreenState();
}

class _PedidoAdicionarClienteScreenState
    extends BaseScreenState<PedidoAdicionarClienteScreen> {
  late final PedidoAdicionarClienteControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoAdicionarClienteControllers();
    _controllers.pesquisaCliente.controller.addListener(_onPesquisarChanged);
  }

  @override
  void dispose() {
    _controllers.pesquisaCliente.controller.removeListener(_onPesquisarChanged);
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(pedidoAdicionarViewModelProvider);
    final filteredClientes = viewModel.clientes != null
        ? _filtrarClientes(viewModel.clientes!)
        : null;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: kColorStylePrimary0,
                ),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTituloBarDefault(
                          title: 'Novo Pedido',
                          child: Text(
                            '(1/4)',
                            style: kTestStyleBoldText14.copyWith(
                              color: kColorStyleSecondinaryLight400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomStepperItem(
                                    title: "Cliente",
                                    active: true,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Produtos",
                                    active: false,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Pagamento",
                                    active: false,
                                  ),
                                  CustomStepperLine(),
                                  CustomStepperItem(
                                    title: "Revisão",
                                    active: false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              buildTextField(_controllers.pesquisaCliente),
                              const SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  viewModel.listarClienteCommand.running
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              filteredClientes?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            final cliente =
                                                filteredClientes![index];
                                            return ClienteCard(
                                              cliente: cliente,
                                              isSelected:
                                                  viewModel
                                                      .selectedCliente
                                                      ?.id ==
                                                  cliente.id,
                                              onTap: () {
                                                ref
                                                    .read(
                                                      pedidoAdicionarViewModelProvider
                                                          .notifier,
                                                    )
                                                    .selectCliente(cliente);
                                              },
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: kColorStyleSecondinaryLight200),
                      const SizedBox(height: 5),
                      //buildSubmitButton(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomButtonSecondary(
                              label: 'Cancelar',
                              onPressed: () {
                                context.pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: 'Próximo',
                              onPressed: () {
                                _handleSalvarPressed();
                              },
                            ),
                          ),
                        ],
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

  Future<void> _handleSalvarPressed() async {
    final clienteState = ref.read(pedidoAdicionarViewModelProvider);
    final cliente = clienteState.selectedCliente;

    if (cliente == null) {
      showSnackBar('Selecione um cliente para continuar', isError: true);
      return;
    }

    final request = AdicionarPedidoRequest(
      clienteId: cliente.id,
      vendedorId:
          (await ref.read(authLocalStorageProvider).getUsuarioLoginResponse())
              ?.vendedor
              ?.id ??
          0,
      dataPedido: DateTime.now().toUtc().toIso8601String(),
      subtotal: 0,
      valorTotal: 0,
      latitude: cliente.latitude,
      longitude: cliente.longitude,
    );

    final viewModel = ref.read(pedidoAdicionarViewModelProvider);
    final shouldCreateDraft =
        viewModel.pedido == null || viewModel.pedido!.id == 0;

    if (shouldCreateDraft) {
      await viewModel.criarRascunhoCommand.execute(request);
    } else {
      if (viewModel.pedido!.id == 0) {
        showSnackBar('Rascunho inválido. Reinicie o fluxo.', isError: true);
        return;
      }

      await viewModel.atualizarRascunhoCommand.execute((
        pedidoId: viewModel.pedido!.id,
        request: request,
        itens: const [],
        formaPagamentoNome: null,
        condicaoPagamentoNome: null,
        pedidoStatusTipoNome: null,
        substituirItens: false,
      ));
    }

    final comandoCompletou = shouldCreateDraft
        ? viewModel.criarRascunhoCommand.completed
        : viewModel.atualizarRascunhoCommand.completed;

    if (comandoCompletou && mounted) {
      widget.onNext(_controllers.pesquisaCliente.controller.text);
    }
  }

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<ClienteResponse> _filtrarClientes(List<ClienteResponse> clientes) {
    final pesquisa = _controllers.pesquisaCliente.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return clientes;
    }

    return clientes.where((cliente) {
      final nomeFantasia = cliente.nomeFantasia?.toLowerCase() ?? '';
      final razaoSocial = cliente.razaoSocial.toLowerCase();
      final codigo = cliente.codigoCliente?.toLowerCase() ?? '';
      final email = cliente.email?.toLowerCase() ?? '';
      final telefone = cliente.numeroTelefone?.toLowerCase() ?? '';

      return nomeFantasia.contains(pesquisa) ||
          razaoSocial.contains(pesquisa) ||
          codigo.contains(pesquisa) ||
          email.contains(pesquisa) ||
          telefone.contains(pesquisa);
    }).toList();
  }
}
