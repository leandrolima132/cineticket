import 'package:cineticket/data/models/cart_item.dart';

class ReceiptArgs {
  final List<CartItem> items;
  final Map<int, int> halfPricePerItem;

  const ReceiptArgs({
    required this.items,
    required this.halfPricePerItem,
  });
}
