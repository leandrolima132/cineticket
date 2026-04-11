import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/core/widgets/logout_icon_button.dart';
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.outline.withOpacity(0.35),
          ),
        ),
        actions: [
          const LogoutIconButton(),
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (previous, current) =>
                previous.totalItems != current.totalItems,
            builder: (context, state) {
              if (state.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: Badge(
                    backgroundColor: AppColors.accent,
                    label: Text(
                      '${state.totalItems}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    child: const Icon(Icons.confirmation_number_outlined),
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
                    Icon(Icons.local_movies_outlined,
                        size: 80, color: AppColors.textMuted),
                    const SizedBox(height: 24),
                    Text(
                      'Seu carrinho está vazio',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecione assentos em uma sessão para adicionar ingressos.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.movies,
                        (route) => false,
                      ),
                      icon: const Icon(Icons.movie_filter_rounded),
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
