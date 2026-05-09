import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/card/custom_simple_item_list_card.dart';
import 'package:tasko_mobile/domain/condicao_pagamento/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/listar/condicao_pagamento_listar_controllers.dart';
import 'package:tasko_mobile/ui/feature/condicao_pagamento/listar/condicao_pagamento_listar_view_model.dart';

class CondicaoPagamentoListarScreen extends BaseScreen {
  const CondicaoPagamentoListarScreen({super.key});

  @override
  BaseScreenState<CondicaoPagamentoListarScreen> createState() =>
      _CondicaoPagamentoListarScreenState();
}

class _CondicaoPagamentoListarScreenState
    extends BaseScreenState<CondicaoPagamentoListarScreen> {
  late final CondicaoPagamentoListarControllers _controllers;

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    _controllers = CondicaoPagamentoListarControllers();
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
    final viewModel = ref.watch(condicaoPagamentoListarViewModelProvider);
    final condicoesPagamentoFiltradas = _filtrar(
      viewModel.condicoesPagamento ?? [],
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorStylePrimary100,
        body: RefreshIndicator(
          onRefresh: () async {
            await viewModel.listarCondicoesPagamentoCommand.execute();
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
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Condições de Pagamento',
                              style: kTestStyleBoldText24,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButtonPrimary(
                          label: 'Adicionar Condição de Pagamento',
                          onPressed: () async {
                            final adicionado = await context.pushNamed<bool>(
                              'condicoes-pagamento-adicionar',
                            );
                            if (adicionado == true) {
                              showSnackBar(
                                'Condição de pagamento adicionada com sucesso!',
                              );
                              ref
                                  .read(
                                    condicaoPagamentoListarViewModelProvider,
                                  )
                                  .listarCondicoesPagamentoCommand
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
                            viewModel.listarCondicoesPagamentoCommand.running
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : condicoesPagamentoFiltradas.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _controllers.pesquisar.controller.text
                                                .trim()
                                                .isEmpty
                                            ? 'Nenhuma condição de pagamento encontrada.'
                                            : 'Nenhuma condição de pagamento encontrada para a pesquisa.',
                                        style: kTestStyleRegularText14,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        condicoesPagamentoFiltradas.length,
                                    itemBuilder: (context, index) {
                                      final condicaoPagamento =
                                          condicoesPagamentoFiltradas[index];
                                      return CustomSimpleItemListCard(
                                        title:
                                            condicaoPagamento
                                                .descricaoCondicaoPagamento ??
                                            '',
                                        subtitle: 'ID: ${condicaoPagamento.id}',
                                        onTap: _onCustomSimpleItemListCardTap,
                                        id: condicaoPagamento.id,
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

  void _onPesquisarChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onCustomSimpleItemListCardTap(int id) async {
    final atualizado = await context.pushNamed<bool>(
      'condicoes-pagamento-manter',
      pathParameters: {'id': id.toString()},
    );
    if (atualizado == true) {
      showSnackBar('Condição de pagamento atualizada com sucesso!');
      ref
          .read(condicaoPagamentoListarViewModelProvider)
          .listarCondicoesPagamentoCommand
          .execute();
    }
  }

  List<CondicaoPagamentoResponse> _filtrar(
    List<CondicaoPagamentoResponse> condicoesPagamento,
  ) {
    final pesquisa = _controllers.pesquisar.controller.text
        .trim()
        .toLowerCase();

    if (pesquisa.isEmpty) {
      return condicoesPagamento;
    }

    return condicoesPagamento.where((condicaoPagamento) {
      final nome =
          condicaoPagamento.descricaoCondicaoPagamento?.toLowerCase() ?? '';

      return nome.contains(pesquisa);
    }).toList();
  }
}
