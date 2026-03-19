import 'package:flutter/material.dart';

class EmptyCartState extends StatelessWidget {
  final VoidCallback onBackToCart;

  const EmptyCartState({super.key, required this.onBackToCart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'Carrinho vazio',
            style: TextStyle(fontSize: 18, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onBackToCart,
            child: const Text('Voltar ao carrinho'),
          ),
        ],
      ),
    );
  }
}
