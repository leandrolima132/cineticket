import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/modules/checkout/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderSummaryItem extends StatelessWidget {
  final CartItem item;
  final double fullPrice;
  final double halfPrice;
  final int halfPriceCount;
  final void Function(int) onHalfPriceChanged;

  const OrderSummaryItem({
    super.key,
    required this.item,
    required this.fullPrice,
    required this.halfPrice,
    required this.halfPriceCount,
    required this.onHalfPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM');
    final fullCount = item.totalTickets - halfPriceCount;
    final subtotal =
        PaymentConstants.calculateSubtotal(item.totalTickets, halfPriceCount);
    final priceFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.movie.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${item.showtime.theater} • ${dateFormat.format(item.showtime.dateTime)} ${timeFormat.format(item.showtime.dateTime)}',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          Text(
            'Assentos: ${item.seatsLabel}',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.school_rounded, size: 16, color: AppColors.spotlightSoft),
              const SizedBox(width: 6),
              const Text(
                'Meia (estudante):',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: halfPriceCount.clamp(0, item.totalTickets),
                dropdownColor: AppColors.surfaceElevated,
                underline: const SizedBox.shrink(),
                items: List.generate(
                  item.totalTickets + 1,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(
                      i == 0 ? 'Nenhum' : '$i de ${item.totalTickets}',
                      style: TextStyle(
                        fontSize: 13,
                        color: i > 0 ? AppColors.spotlightSoft : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
                onChanged: (v) => onHalfPriceChanged(v ?? 0),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  fullCount > 0 && halfPriceCount > 0
                      ? '$fullCount inteira × ${priceFormat.format(fullPrice)} + $halfPriceCount meia × ${priceFormat.format(halfPrice)}'
                      : '${item.totalTickets} ingresso(s) × ${priceFormat.format(fullCount > 0 ? fullPrice : halfPrice)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
              Text(
                priceFormat.format(subtotal),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
