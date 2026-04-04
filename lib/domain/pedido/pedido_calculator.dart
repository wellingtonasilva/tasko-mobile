import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';

class PedidoCalculator {
  const PedidoCalculator._();

  static double calcularItemTotal({
    required double quantidade,
    required double precoUnitario,
    double? percentualDesconto,
  }) {
    final bruto = quantidade * precoUnitario;
    if (percentualDesconto == null || percentualDesconto <= 0) {
      return _round(bruto);
    }
    final desconto = bruto * (percentualDesconto / 100);
    return _round(bruto - desconto);
  }

  static double calcularItemDesconto({
    required double quantidade,
    required double precoUnitario,
    double? percentualDesconto,
  }) {
    if (percentualDesconto == null || percentualDesconto <= 0) return 0;
    final bruto = quantidade * precoUnitario;
    return _round(bruto * (percentualDesconto / 100));
  }

  static double calcularSubtotal(List<PedidoItemResponse> itens) {
    if (itens.isEmpty) return 0;
    return _round(itens.fold<double>(0, (sum, item) => sum + item.valorTotal));
  }

  static double calcularDescontoValor({
    required double subtotal,
    double? percentualDesconto,
  }) {
    if (percentualDesconto == null || percentualDesconto <= 0) return 0;
    return _round(subtotal * (percentualDesconto / 100));
  }

  static double calcularTotal({
    required double subtotal,
    double? valorDesconto,
    double? valorFrete,
  }) {
    return _round(subtotal - (valorDesconto ?? 0) + (valorFrete ?? 0));
  }

  static double _round(double value) {
    return (value * 100).roundToDouble() / 100;
  }
}
