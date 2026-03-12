import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_event.dart';
import 'package:cineticket/modules/cart/cart_state.dart';
import 'package:cineticket/modules/cart/widgets/cart_bottom_bar.dart';
import 'package:cineticket/modules/cart/widgets/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Carrinho'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (previous, current) =>
                previous.totalItems != current.totalItems,
            builder: (context, state) {
              if (state.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Badge(
                    label: Text('${state.totalItems}'),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 80, color: Colors.grey[600]),
                    const SizedBox(height: 24),
                    Text(
                      'Seu carrinho está vazio',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecione assentos em uma sessão para adicionar ingressos.',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.movies,
                        (route) => false,
                      ),
                      icon: const Icon(Icons.movie),
                      label: const Text('Ver filmes'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return CartItemCard(
                      key: ObjectKey(item),
                      item: item,
                      onRemove: () => context
                          .read<CartBloc>()
                          .add(RemoveFromCartEvent(index)),
                    );
                  },
                ),
              ),
              CartBottomBar(
                totalTickets: state.totalItems,
                onConfirm: () =>
                    Navigator.pushNamed(context, AppRoutes.payment),
              ),
            ],
          );
        },
      ),
    );
  }
}
