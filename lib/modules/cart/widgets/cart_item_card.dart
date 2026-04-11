import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.movie.posterUrl,
                width: 64,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 96,
                  color: AppColors.surface,
                  child: const Icon(Icons.movie_rounded,
                      color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
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
                  const SizedBox(height: 6),
                  Text(
                    '${item.showtime.theater} • ${item.showtime.room}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${dateFormat.format(item.showtime.dateTime)} às ${timeFormat.format(item.showtime.dateTime)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.28),
                      ),
                    ),
                    child: Text(
                      'Assentos: ${item.seatsLabel}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.textMuted,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceElevated.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
