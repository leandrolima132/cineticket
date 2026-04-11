import 'package:cineticket/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CartBottomBar extends StatelessWidget {
  final int totalTickets;
  final VoidCallback onConfirm;

  const CartBottomBar({
    super.key,
    required this.totalTickets,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outline.withOpacity(0.45)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.voidBlack.withOpacity(0.5),
            blurRadius: 28,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total no carrinho',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$totalTickets ingresso(s)',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.payment_rounded, size: 20),
              label: const Text('Finalizar compra'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
