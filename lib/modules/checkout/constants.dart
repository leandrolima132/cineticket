abstract class PaymentConstants {
  static const double fullPrice = 32.0;
  static const double halfPrice = 16.0;

  static double calculateSubtotal(int totalTickets, int halfPriceCount) {
    final fullCount = totalTickets - halfPriceCount;
    return fullCount * fullPrice + halfPriceCount * halfPrice;
  }
}
