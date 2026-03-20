import 'package:cineticket/modules/checkout/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentConstants.calculateSubtotal', () {
    test('só inteiras: totalTickets × preço inteira', () {
      expect(
        PaymentConstants.calculateSubtotal(3, 0),
        3 * PaymentConstants.fullPrice,
      );
    });

    test('só meias: totalTickets × preço meia', () {
      expect(
        PaymentConstants.calculateSubtotal(2, 2),
        2 * PaymentConstants.halfPrice,
      );
    });

    test('mistura inteira e meia', () {
      expect(
        PaymentConstants.calculateSubtotal(4, 2),
        2 * PaymentConstants.fullPrice + 2 * PaymentConstants.halfPrice,
      );
    });

    test('um ingresso meia', () {
      expect(
        PaymentConstants.calculateSubtotal(1, 1),
        PaymentConstants.halfPrice,
      );
    });
  });
}
