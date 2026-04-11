import 'package:cineticket/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyCartState extends StatelessWidget {
  final VoidCallback onBackToCart;

  const EmptyCartState({super.key, required this.onBackToCart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 72, color: AppColors.textMuted.withOpacity(0.85)),
            const SizedBox(height: 20),
            Text(
              'Carrinho vazio',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione ingressos antes de pagar.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: onBackToCart,
              child: const Text('Voltar ao carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}
