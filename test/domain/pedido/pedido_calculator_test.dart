import 'package:flutter_test/flutter_test.dart';
import 'package:tasko_mobile/domain/pedido/pedido_calculator.dart';
import 'package:tasko_mobile/domain/pedido/response/pedido_item_response.dart';

void main() {
  group('PedidoCalculator', () {
    group('calcularItemTotal', () {
      test('returns quantidade * precoUnitario when no discount', () {
        expect(
          PedidoCalculator.calcularItemTotal(
            quantidade: 10,
            precoUnitario: 25.50,
          ),
          255.0,
        );
      });

      test('applies percentual discount', () {
        expect(
          PedidoCalculator.calcularItemTotal(
            quantidade: 10,
            precoUnitario: 100.0,
            percentualDesconto: 10,
          ),
          900.0,
        );
      });

      test('zero discount returns full price', () {
        expect(
          PedidoCalculator.calcularItemTotal(
            quantidade: 5,
            precoUnitario: 20.0,
            percentualDesconto: 0,
          ),
          100.0,
        );
      });

      test('rounds to 2 decimal places', () {
        expect(
          PedidoCalculator.calcularItemTotal(
            quantidade: 3,
            precoUnitario: 9.99,
          ),
          29.97,
        );
      });
    });

    group('calcularItemDesconto', () {
      test('returns 0 when no discount', () {
        expect(
          PedidoCalculator.calcularItemDesconto(
            quantidade: 10,
            precoUnitario: 100.0,
          ),
          0,
        );
      });

      test('calculates discount value', () {
        expect(
          PedidoCalculator.calcularItemDesconto(
            quantidade: 10,
            precoUnitario: 100.0,
            percentualDesconto: 15,
          ),
          150.0,
        );
      });
    });

    group('calcularSubtotal', () {
      test('returns 0 for empty list', () {
        expect(PedidoCalculator.calcularSubtotal([]), 0);
      });

      test('sums valorTotal of all items', () {
        final itens = [
          PedidoItemResponse(
            id: 1,
            pedidoId: 1,
            produtoId: 1,
            quantidade: 2,
            precoUnitario: 50.0,
            valorTotal: 100.0,
          ),
          PedidoItemResponse(
            id: 2,
            pedidoId: 1,
            produtoId: 2,
            quantidade: 3,
            precoUnitario: 30.0,
            valorTotal: 90.0,
          ),
        ];
        expect(PedidoCalculator.calcularSubtotal(itens), 190.0);
      });
    });

    group('calcularDescontoValor', () {
      test('returns 0 when no discount', () {
        expect(PedidoCalculator.calcularDescontoValor(subtotal: 500.0), 0);
      });

      test('calculates discount from subtotal', () {
        expect(
          PedidoCalculator.calcularDescontoValor(
            subtotal: 500.0,
            percentualDesconto: 10,
          ),
          50.0,
        );
      });
    });

    group('calcularTotal', () {
      test('subtotal only', () {
        expect(PedidoCalculator.calcularTotal(subtotal: 500.0), 500.0);
      });

      test('subtotal - desconto', () {
        expect(
          PedidoCalculator.calcularTotal(subtotal: 500.0, valorDesconto: 50.0),
          450.0,
        );
      });

      test('subtotal - desconto + frete', () {
        expect(
          PedidoCalculator.calcularTotal(
            subtotal: 500.0,
            valorDesconto: 50.0,
            valorFrete: 25.0,
          ),
          475.0,
        );
      });

      test('subtotal + frete when no discount', () {
        expect(
          PedidoCalculator.calcularTotal(subtotal: 200.0, valorFrete: 15.50),
          215.50,
        );
      });
    });
  });
}
