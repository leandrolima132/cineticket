import 'package:cineticket/core/router/receipt_args.dart';
import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_event.dart';
import 'package:cineticket/modules/checkout/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ReceiptArgs;
    final priceFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final timeFormat = DateFormat('HH:mm');
    final sessionDateFormat = DateFormat('dd/MM');

    double total = 0;
    for (var i = 0; i < args.items.length; i++) {
      final item = args.items[i];
      final halfCount = args.halfPricePerItem[i] ?? 0;
      total += PaymentConstants.calculateSubtotal(item.totalTickets, halfCount);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Comprovante'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.success.withOpacity(0.18),
                    AppColors.surfaceElevated.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.success.withOpacity(0.35)),
              ),
              child: Column(
                children: [
                  Icon(Icons.verified_rounded,
                      color: AppColors.success, size: 56),
                  const SizedBox(height: 12),
                  Text(
                    'Pagamento realizado com sucesso!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated.withOpacity(0.85),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outline.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido ${DateTime.now().millisecondsSinceEpoch % 100000}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data: ${dateFormat.format(DateTime.now())}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...args.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final halfCount = args.halfPricePerItem[index] ?? 0;
              final fullCount = item.totalTickets - halfCount;
              final subtotal = PaymentConstants.calculateSubtotal(
                  item.totalTickets, halfCount);
              return _buildReceiptItem(
                item: item,
                fullCount: fullCount,
                halfCount: halfCount,
                subtotal: subtotal,
                priceFormat: priceFormat,
                timeFormat: timeFormat,
                sessionDateFormat: sessionDateFormat,
              );
            }),
            Divider(color: AppColors.outline.withOpacity(0.5), height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total pago',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                Text(
                  priceFormat.format(total),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.spotlightSoft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.read<CartBloc>().add(const ClearCartEvent());
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.movies,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text('Voltar ao início'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptItem({
    required CartItem item,
    required int fullCount,
    required int halfCount,
    required double subtotal,
    required NumberFormat priceFormat,
    required DateFormat timeFormat,
    required DateFormat sessionDateFormat,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withOpacity(0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline.withOpacity(0.35)),
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
          const SizedBox(height: 8),
          Text(
            '${item.showtime.theater} • Sala ${item.showtime.room}',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          Text(
            '${sessionDateFormat.format(item.showtime.dateTime)} às ${timeFormat.format(item.showtime.dateTime)}',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Text(
            'Assentos: ${item.seatsLabel}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          if (fullCount > 0 && halfCount > 0)
            Text(
              '$fullCount inteira × ${priceFormat.format(PaymentConstants.fullPrice)} + $halfCount meia × ${priceFormat.format(PaymentConstants.halfPrice)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            )
          else
            Text(
              '${item.totalTickets} ingresso(s) × ${priceFormat.format(fullCount > 0 ? PaymentConstants.fullPrice : PaymentConstants.halfPrice)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                priceFormat.format(subtotal),
                style: const TextStyle(
                  fontSize: 16,
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
