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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$totalTickets ingresso(s)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[300]),
            ),
            SizedBox(
              width: 200,
              child: FilledButton.icon(
                onPressed: onConfirm,
                icon: const Icon(Icons.shopping_cart_checkout, size: 20),
                label: const Text('Finalizar compra'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
