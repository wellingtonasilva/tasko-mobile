import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/domain/pedido/pedido_calculator.dart';
import 'package:tasko_mobile/domain/produto/response/produto_response.dart';
import 'package:tasko_mobile/ui/feature/pedido/criar/pedido_criar_ui_state.dart';

class PedidoItemFormDialog extends StatefulWidget {
  final List<ProdutoResponse> produtos;
  final void Function(PedidoItemEntry entry) onAdicionar;

  const PedidoItemFormDialog({
    super.key,
    required this.produtos,
    required this.onAdicionar,
  });

  @override
  State<PedidoItemFormDialog> createState() => _PedidoItemFormDialogState();
}

class _PedidoItemFormDialogState extends State<PedidoItemFormDialog> {
  ProdutoResponse? _produtoSelecionado;
  final _quantidadeController = TextEditingController(text: '1');
  final _precoController = TextEditingController();
  final _descontoController = TextEditingController(text: '0');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _quantidadeController.dispose();
    _precoController.dispose();
    _descontoController.dispose();
    super.dispose();
  }

  void _onProdutoChanged(ProdutoResponse? produto) {
    setState(() {
      _produtoSelecionado = produto;
      if (produto?.precoSugerido != null) {
        _precoController.text = produto!.precoSugerido!.toStringAsFixed(2);
      }
    });
  }

  void _handleAdicionar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_produtoSelecionado == null) return;

    final quantidade =
        double.tryParse(_quantidadeController.text.replaceAll(',', '.')) ?? 0;
    final preco =
        double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0;
    final desconto = double.tryParse(
      _descontoController.text.replaceAll(',', '.'),
    );

    final valorDesconto = PedidoCalculator.calcularItemDesconto(
      quantidade: quantidade,
      precoUnitario: preco,
      percentualDesconto: desconto,
    );
    final valorTotal = PedidoCalculator.calcularItemTotal(
      quantidade: quantidade,
      precoUnitario: preco,
      percentualDesconto: desconto,
    );

    widget.onAdicionar(
      PedidoItemEntry(
        produto: _produtoSelecionado!,
        quantidade: quantidade,
        precoUnitario: preco,
        percentualDesconto: desconto,
        valorDesconto: valorDesconto,
        valorTotal: valorTotal,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Adicionar Item',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ProdutoResponse>(
                  decoration: const InputDecoration(
                    labelText: 'Produto',
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  initialValue: _produtoSelecionado,
                  items: widget.produtos
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            p.nomeProduto,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _onProdutoChanged,
                  validator: (v) => v == null ? 'Selecione um produto' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final val = double.tryParse(v?.replaceAll(',', '.') ?? '');
                    if (val == null || val <= 0) return 'Informe a quantidade';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _precoController,
                  decoration: const InputDecoration(
                    labelText: 'Preco Unitario (R\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final val = double.tryParse(v?.replaceAll(',', '.') ?? '');
                    if (val == null || val <= 0) return 'Informe o preco';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descontoController,
                  decoration: const InputDecoration(
                    labelText: 'Desconto (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            kColorStylePrimaryNeutralPaletteDark600,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _handleAdicionar,
                      child: const Text('Adicionar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
