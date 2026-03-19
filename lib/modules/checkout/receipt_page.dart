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
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[400], size: 56),
                  const SizedBox(height: 12),
                  Text(
                    'Pagamento realizado com sucesso!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido ${DateTime.now().millisecondsSinceEpoch % 100000}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data: ${dateFormat.format(DateTime.now())}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[400]),
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
                context,
                item: item,
                fullCount: fullCount,
                halfCount: halfCount,
                subtotal: subtotal,
                priceFormat: priceFormat,
                timeFormat: timeFormat,
                sessionDateFormat: sessionDateFormat,
              );
            }),
            const Divider(color: Colors.grey, height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total pago',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                Text(
                  priceFormat.format(total),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent[400],
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
                icon: const Icon(Icons.home),
                label: const Text('Voltar ao início'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptItem(
    BuildContext context, {
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
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.movie.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${item.showtime.theater} • Sala ${item.showtime.room}',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
          Text(
            '${sessionDateFormat.format(item.showtime.dateTime)} às ${timeFormat.format(item.showtime.dateTime)}',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
          const SizedBox(height: 6),
          Text(
            'Assentos: ${item.seatsLabel}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          if (fullCount > 0 && halfCount > 0)
            Text(
              '$fullCount inteira × ${priceFormat.format(PaymentConstants.fullPrice)} + $halfCount meia × ${priceFormat.format(PaymentConstants.halfPrice)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            )
          else
            Text(
              '${item.totalTickets} ingresso(s) × ${priceFormat.format(fullCount > 0 ? PaymentConstants.fullPrice : PaymentConstants.halfPrice)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                priceFormat.format(subtotal),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
