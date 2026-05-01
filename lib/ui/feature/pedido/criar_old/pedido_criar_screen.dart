import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/appbar/custom_titulo_bar_default.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';
import 'package:tasko_mobile/common/widgets/custom_dropdown_button_form_field.dart';
import 'package:tasko_mobile/domain/cliente/response/cliente_response.dart';
import 'package:tasko_mobile/domain/pedido/response/condicao_pagamento_response.dart';
import 'package:tasko_mobile/domain/pedido/response/forma_pagamento_response.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pedido_criar_ui_state.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pedido_criar_view_model.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar_old/pedido_item_form_dialog.dart';
import 'package:tasko_mobile/util/result.dart';

class PedidoCriarScreen extends BaseScreen {
  const PedidoCriarScreen({super.key});

  @override
  BaseScreenState<PedidoCriarScreen> createState() => _PedidoCriarScreenState();
}

class _PedidoCriarScreenState extends BaseScreenState<PedidoCriarScreen> {
  int _currentStep = 0;
  static const int _totalSteps =
      5; // Vendedor, Cliente, Itens, Pagamento, Resumo
  String _formatCurrency(double value) => 'R\$ ${value.toStringAsFixed(2)}';

  @override
  bool get useScaffold => false;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(pedidoCriarViewModelProvider.notifier);
    viewModel.showSnackBar = (String message, Result result) {
      if (!mounted) return;
      showSnackBar(message, isError: result is Failure);
    };
    viewModel.onSalvarSucesso = () {
      if (mounted) Navigator.of(context).pop(true);
    };
    ref.read(pedidoCriarViewModelProvider).carregarDadosCommand.execute();
  }

  @override
  Widget buildContent(BuildContext context) {
    final uiState = ref.watch(pedidoCriarViewModelProvider);
    final viewModel = ref.read(pedidoCriarViewModelProvider.notifier);

    if (uiState.carregarDadosCommand.running) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: kColorStylePrimary0,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTituloBarDefault(
                      title: 'Novo Pedido',
                      onClosePressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Expanded(
                    child: Stepper(
                      currentStep: _currentStep,
                      type: StepperType.vertical,
                      onStepContinue: () {
                        if (_currentStep < _totalSteps - 1) {
                          setState(() => _currentStep += 1);
                        } else {
                          uiState.salvarPedidoCommand.execute(null);
                        }
                      },
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep -= 1);
                        }
                      },
                      controlsBuilder: (context, details) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              if (_currentStep > 0)
                                Expanded(
                                  child: CustomButtonSecondary(
                                    label: 'Voltar',
                                    onPressed: () =>
                                        details.onStepCancel?.call(),
                                  ),
                                ),
                              if (_currentStep > 0) const SizedBox(width: 12),
                              Expanded(
                                child: CustomButtonPrimary(
                                  label: _currentStep < _totalSteps - 1
                                      ? 'Proximo'
                                      : 'Salvar Pedido',
                                  onPressed: () =>
                                      details.onStepContinue?.call(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      steps: [
                        Step(
                          title: const Text('Vendedor'),
                          isActive: _currentStep >= 0,
                          state: uiState.vendedorSelecionado != null
                              ? StepState.complete
                              : StepState.indexed,
                          content: _buildVendedorStep(uiState, viewModel),
                        ),
                        Step(
                          title: const Text('Cliente'),
                          isActive: _currentStep >= 1,
                          state: uiState.clienteSelecionado != null
                              ? StepState.complete
                              : StepState.indexed,
                          content: _buildClienteStep(uiState, viewModel),
                        ),
                        Step(
                          title: const Text('Itens'),
                          isActive: _currentStep >= 2,
                          state: uiState.itens.isNotEmpty
                              ? StepState.complete
                              : StepState.indexed,
                          content: _buildItensStep(uiState, viewModel),
                        ),
                        Step(
                          title: const Text('Pagamento'),
                          isActive: _currentStep >= 3,
                          content: _buildPagamentoStep(uiState, viewModel),
                        ),
                        Step(
                          title: const Text('Resumo'),
                          isActive: _currentStep >= 4,
                          content: _buildResumoStep(uiState),
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
    );
  }

  Widget _buildVendedorStep(
    PedidoCriarUiState uiState,
    PedidoCriarViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<VendedorResponse>(
          decoration: const InputDecoration(
            labelText: 'Selecionar Vendedor',
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
          value: uiState.vendedorSelecionado,
          items: uiState.vendedores
              .map(
                (v) => DropdownMenuItem(
                  value: v,
                  child: Text(v.nomeVendedor, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: viewModel.selecionarVendedor,
        ),
        if (uiState.vendedorSelecionado != null) ...[
          const SizedBox(height: 8),
          Text(
            'Código:  0{uiState.vendedorSelecionado!.codigoVendedor}',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            'E-mail:  {uiState.vendedorSelecionado!.email}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildClienteStep(
    PedidoCriarUiState uiState,
    PedidoCriarViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<ClienteResponse>(
          decoration: const InputDecoration(
            labelText: 'Selecionar Cliente',
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
          initialValue: uiState.clienteSelecionado,
          items: uiState.clientes
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.razaoSocial, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: viewModel.selecionarCliente,
        ),
        if (uiState.clienteSelecionado != null) ...[
          const SizedBox(height: 8),
          Text(
            'CNPJ/CPF: ${uiState.clienteSelecionado!.cnpjCpf ?? '-'}',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            'Cidade: ${uiState.clienteSelecionado!.cidade ?? '-'} - ${uiState.clienteSelecionado!.estado ?? '-'}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildItensStep(
    PedidoCriarUiState uiState,
    PedidoCriarViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorStylePrimaryNeutralPaletteDark600,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => PedidoItemFormDialog(
                produtos: uiState.produtos,
                onAdicionar: viewModel.adicionarItem,
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Adicionar Item'),
        ),
        const SizedBox(height: 12),
        if (uiState.itens.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Nenhum item adicionado.', textAlign: TextAlign.center),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uiState.itens.length,
            itemBuilder: (context, index) {
              final item = uiState.itens[index];
              return Card(
                child: ListTile(
                  title: Text(item.produto.nomeProduto),
                  subtitle: Text(
                    '${item.quantidade} x ${_formatCurrency(item.precoUnitario)} = ${_formatCurrency(item.valorTotal)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => viewModel.removerItem(index),
                  ),
                ),
              );
            },
          ),
        if (uiState.itens.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Subtotal: ${_formatCurrency(uiState.subtotal)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
      ],
    );
  }

  Widget _buildPagamentoStep(
    PedidoCriarUiState uiState,
    PedidoCriarViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<FormaPagamentoResponse>(
          decoration: const InputDecoration(
            labelText: 'Forma de Pagamento',
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
          initialValue: uiState.formaPagamentoSelecionada,
          items: uiState.formasPagamento
              .map(
                (f) => DropdownMenuItem(
                  value: f,
                  child: Text(f.descricaoFormaPagamento ?? ''),
                ),
              )
              .toList(),
          onChanged: viewModel.selecionarFormaPagamento,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<CondicaoPagamentoResponse>(
          decoration: const InputDecoration(
            labelText: 'Condicao de Pagamento',
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
          initialValue: uiState.condicaoPagamentoSelecionada,
          items: uiState.condicoesPagamento
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.descricaoCondicaoPagamento ?? ''),
                ),
              )
              .toList(),
          onChanged: viewModel.selecionarCondicaoPagamento,
        ),
      ],
    );
  }

  Widget _buildResumoStep(PedidoCriarUiState uiState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _resumoRow('Cliente', uiState.clienteSelecionado?.razaoSocial ?? '-'),
        _resumoRow('Itens', '${uiState.itens.length} produto(s)'),
        _resumoRow('Subtotal', _formatCurrency(uiState.subtotal)),
        _resumoRow('Desconto', _formatCurrency(uiState.valorDesconto)),
        _resumoRow('Frete', _formatCurrency(uiState.valorFrete)),
        const Divider(),
        _resumoRow('Total', _formatCurrency(uiState.valorTotal), bold: true),
        _resumoRow(
          'Forma Pagamento',
          uiState.formaPagamentoSelecionada?.descricaoFormaPagamento ?? '-',
        ),
        _resumoRow(
          'Condicao Pagamento',
          uiState.condicaoPagamentoSelecionada?.descricaoCondicaoPagamento ??
              '-',
        ),
      ],
    );
  }

  Widget _resumoRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
