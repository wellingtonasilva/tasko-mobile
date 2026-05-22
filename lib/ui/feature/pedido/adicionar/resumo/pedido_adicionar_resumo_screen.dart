import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_action_edit_icon_button.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/pedido_adicionar_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/adicionar/resumo/pedido_adicionar_resumo_controllers.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoAdicionarResumoScreen extends BaseScreen {
  final Function(String cliente) onPrevious;
  final Function(String cliente) onNext;

  const PedidoAdicionarResumoScreen({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  BaseScreenState<PedidoAdicionarResumoScreen> createState() =>
      _PedidoAdicionarResumoScreenState();
}

class _PedidoAdicionarResumoScreenState
    extends BaseScreenState<PedidoAdicionarResumoScreen> {
  late final PedidoAdicionarResumoControllers _controllers;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(pedidoAdicionarViewModelProvider.notifier);
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
      if (mounted) showLoading();
    };
    viewModel.onFinishEvent = () {
      if (mounted) hideLoading();
    };
    viewModel.onConfirmado = () {
      if (mounted) widget.onNext('Resumo');
    };
  }

  @override
  Widget buildContent(BuildContext context) {
    final viewModel = ref.watch(pedidoAdicionarViewModelProvider);
    final rascunho = viewModel.pedido;

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
                          title:
                              'Pedido - ${viewModel.selectedCliente?.nomeFantasia ?? ''}',
                          child: Text(
                            '(4/4)',
                            style: kTestStyleBoldText14.copyWith(
                              color: kColorStyleSecondinaryLight400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Expanded(
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
                                  active: true,
                                ),
                                CustomStepperLine(),
                                CustomStepperItem(
                                  title: "Pagamento",
                                  active: true,
                                ),
                                CustomStepperLine(),
                                CustomStepperItem(
                                  title: "Revisão",
                                  active: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Cliente
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Cliente',
                                          style: kTestStyleBoldText16,
                                        ),
                                      ),
                                      CustomActionEditIconButton(
                                        onPressed: () {
                                          widget.onPrevious("Cliente");
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    viewModel.selectedCliente?.nomeFantasia ??
                                        viewModel
                                            .selectedCliente
                                            ?.razaoSocial ??
                                        '',
                                    style: kTestStyleBoldText14.copyWith(
                                      color: kColorStyleSecondinaryDarkDefault,
                                    ),
                                  ),
                                  Text(
                                    'Limite disponível: R\$ ${viewModel.selectedCliente?.limiteCredito?.toStringAsFixed(2) ?? 'N/A'}',
                                    style: kTestStyleRegularText14.copyWith(
                                      color: kColorStyleSecondinaryLight400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Produtos
                            const SizedBox(height: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Produtos',
                                              style: kTestStyleBoldText16,
                                            ),
                                          ),
                                          CustomActionEditIconButton(
                                            onPressed: () {
                                              widget.onPrevious("Cliente");
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      viewModel.listarProdutoCommand.running
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Expanded(
                                              child: ListView.builder(
                                                itemCount: viewModel
                                                    .carrinhoQuantidades
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final entry = viewModel
                                                      .carrinhoQuantidades
                                                      .entries
                                                      .elementAt(index);
                                                  final produto = viewModel
                                                      .produtos
                                                      ?.firstWhere(
                                                        (p) =>
                                                            p.id == entry.key,
                                                        orElse: () => viewModel
                                                            .produtos!
                                                            .first,
                                                      );
                                                  if (produto == null) {
                                                    return const SizedBox();
                                                  }
                                                  final total =
                                                      (produto.precoSugerido ??
                                                          0) *
                                                      entry.value;
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        produto.nomeProduto ??
                                                            '',
                                                        style: kTestStyleMediumText14
                                                            .copyWith(
                                                              color:
                                                                  kColorStyleSecondinaryDarkDefault,
                                                            ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Código: ${produto.codigoProduto ?? ''}",
                                                            style: kTestStyleRegularText14
                                                                .copyWith(
                                                                  color:
                                                                      kColorStyleSecondinaryLight400,
                                                                ),
                                                          ),
                                                          Text(
                                                            "Qtd: ${entry.value.toInt()}",
                                                            style: kTestStyleRegularText14
                                                                .copyWith(
                                                                  color:
                                                                      kColorStyleSecondinaryLight400,
                                                                ),
                                                          ),
                                                          Text(
                                                            "R\$ ${total.toStringAsFixed(2)}",
                                                            style: kTestStyleRegularText14
                                                                .copyWith(
                                                                  color:
                                                                      kColorStyleSecondinaryDarkDefault,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (index <
                                                          viewModel
                                                                  .carrinhoQuantidades
                                                                  .length -
                                                              1)
                                                        Divider(
                                                          color:
                                                              kColorStyleSecondinaryLight200,
                                                        ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Pagamento
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pagamento',
                                    style: kTestStyleBoldText16,
                                  ),
                                ),
                                CustomActionEditIconButton(
                                  onPressed: () {
                                    widget.onPrevious("Pagamento");
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              rascunho?.formaPagamentoNome ?? '',
                              style: kTestStyleBoldText14.copyWith(
                                color: kColorStyleSecondinaryDarkDefault,
                              ),
                            ),
                            Text(
                              rascunho?.condicaoPagamentoNome ?? '',
                              style: kTestStyleRegularText14.copyWith(
                                color: kColorStyleSecondinaryLight400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Total do pedido
                      Container(
                        height: 75,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                "Total do pedido",
                                style: kTestStyleMediumText18.copyWith(
                                  color: kColorStyleSecondinaryDarkDefault,
                                ),
                              ),
                            ),
                            Text(
                              "R\$ ${(rascunho?.valorTotal ?? viewModel.valorTotal).toStringAsFixed(2)}",
                              style: kTestStyleBoldText24.copyWith(
                                color: kColorStylePrimaryNeutralPaletteDark500,
                              ),
                            ),
                          ],
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
                              label: 'Voltar',
                              onPressed: () {
                                widget.onPrevious("Pagamento");
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButtonPrimary(
                              label: true == true
                                  ? 'Salvar Alterações'
                                  : 'Confirmar Pedido',
                              onPressed: () =>
                                  viewModel.confirmarCommand.execute(),
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
}
