import 'package:cineticket/core/router/receipt_args.dart';
import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_state.dart';
import 'package:cineticket/modules/checkout/widgets/empty_cart_state.dart';
import 'package:cineticket/modules/checkout/widgets/order_summary_section.dart';
import 'package:cineticket/modules/checkout/widgets/payment_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final Map<int, int> _halfPricePerItem = {};

  void _onPay(BuildContext context, CartState state) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isProcessing = true);
    Navigator.pushNamed(
      context,
      AppRoutes.receipt,
      arguments: ReceiptArgs(
        items: List.from(state.items),
        halfPricePerItem: Map.from(_halfPricePerItem),
      ),
    ).then((_) => setState(() => _isProcessing = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pagamento')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return EmptyCartState(onBackToCart: () => Navigator.pop(context));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderSummarySection(
                  items: state.items,
                  halfPricePerItem: _halfPricePerItem,
                  onHalfPriceChanged: (index, count) {
                    setState(() => _halfPricePerItem[index] = count);
                  },
                ),
                const SizedBox(height: 32),
                PaymentForm(
                  formKey: _formKey,
                  onPay: () => _onPay(context, state),
                  isProcessing: _isProcessing,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
