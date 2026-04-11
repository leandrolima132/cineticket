import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/modules/checkout/constants.dart';
import 'package:cineticket/modules/checkout/widgets/order_summary_item.dart';
import 'package:flutter/material.dart';

class OrderSummarySection extends StatelessWidget {
  final List<CartItem> items;
  final Map<int, int> halfPricePerItem;
  final void Function(int index, int count) onHalfPriceChanged;

  const OrderSummarySection({
    super.key,
    required this.items,
    required this.halfPricePerItem,
    required this.onHalfPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo do pedido',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 12),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return OrderSummaryItem(
            item: item,
            fullPrice: PaymentConstants.fullPrice,
            halfPrice: PaymentConstants.halfPrice,
            halfPriceCount: halfPricePerItem[index] ?? 0,
            onHalfPriceChanged: (count) => onHalfPriceChanged(index, count),
          );
        }),
        Divider(color: AppColors.outline.withOpacity(0.5)),
      ],
    );
  }
}
