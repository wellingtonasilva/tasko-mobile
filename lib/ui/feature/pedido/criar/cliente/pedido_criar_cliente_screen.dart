import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/auth_persistence.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/cliente/pedido_criar_cliente_controllers.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/domain/pedido/request/adicionar_pedido_request.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_rascunho_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/cliente/pedido_criar_cliente_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/cliente/widgets/cliente_card.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoCriarClienteScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;
  const PedidoCriarClienteScreen({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  BaseScreenState<PedidoCriarClienteScreen> createState() =>
      _PedidoCriarClienteScreenState();
}

class _PedidoCriarClienteScreenState
    extends BaseScreenState<PedidoCriarClienteScreen> {
  late PedidoCriarClienteControllers _controllers;
  int activeStep = 1;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controllers = PedidoCriarClienteControllers();

    final viewModel = ref.read(pedidoCriarClienteViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };
    viewModel.onStartEvent = () {
      if (mounted) {
        showLoading();
      }
    };
    viewModel.onFinishEvent = () {
      if (mounted) {
        hideLoading();
      }
    };

    final draftViewModel = ref.read(
      pedidoCriarRascunhoViewModelProvider.notifier,
    );
    draftViewModel.showSnackBar = (String message, Result result) {
      if (mounted) {
        if (result is Success) {
          showSnackBar(message);
        } else if (result is Failure) {
          showSnackBar(message, isError: true);
        }
      }
    };
    draftViewModel.onStartEvent = () {
      if (mounted) {
        showLoading();
      }
    };
    draftViewModel.onFinishEvent = () {
      if (mounted) {
        hideLoading();
      }
    };

    ref
        .read(pedidoCriarClienteViewModelProvider)
        .listarClienteCommand
        .execute();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(pedidoCriarClienteViewModelProvider);

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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                              viewModel.clientes?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            final cliente =
                                                viewModel.clientes![index];
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
                                                      pedidoCriarClienteViewModelProvider
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
                                widget.onPrevious(
                                  _controllers.pesquisaCliente.controller.text,
                                );
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
    final clienteState = ref.read(pedidoCriarClienteViewModelProvider);
    final cliente = clienteState.selectedCliente;

    if (cliente == null) {
      showSnackBar('Selecione um cliente para continuar', isError: true);
      return;
    }

    final request = AdicionarPedidoRequest(
      empresaId:
          (await ref.read(authLocalStorageProvider).getUsuarioLoginResponse())
              ?.empresas
              ?.firstOrNull
              ?.empresaId ??
          0,
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

    final draftState = ref.read(pedidoCriarRascunhoViewModelProvider);
    if (draftState.pedido == null) {
      await draftState.criarRascunhoCommand.execute(request);
    } else {
      await draftState.atualizarRascunhoCommand.execute((
        pedidoId: draftState.pedido!.id,
        request: request,
        itens: const [],
        formaPagamentoNome: null,
        condicaoPagamentoNome: null,
        pedidoStatusTipoNome: null,
        substituirItens: false,
      ));
    }

    final updatedDraftState = ref.read(pedidoCriarRascunhoViewModelProvider);
    if (updatedDraftState.pedido != null) {
      widget.onNext(_controllers.pesquisaCliente.controller.text);
    }
  }
}
