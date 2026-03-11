import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_event.dart';
import 'package:cineticket/modules/seats/seats_bloc.dart';
import 'package:cineticket/modules/seats/seats_event.dart';
import 'package:cineticket/modules/seats/seats_state.dart';
import 'package:cineticket/modules/seats/widgets/legend.dart';
import 'package:cineticket/modules/seats/widgets/seat_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SeatSelectionPage extends StatelessWidget {
  final Movie movie;
  final Showtime showtime;

  const SeatSelectionPage({
    super.key,
    required this.movie,
    required this.showtime,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM');

    return BlocBuilder<SeatsBloc, SeatsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: const Text('Escolha seus assentos')),
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Carregando assentos...',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: const Text('Escolha seus assentos')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.read<SeatsBloc>().add(
                            LoadSeatsEvent(showtime.id),
                          ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Escolha seus assentos')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.movie, color: Colors.redAccent[400]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              showtime.theater,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${showtime.room} • ${dateFormat.format(showtime.dateTime)} ${timeFormat.format(showtime.dateTime)}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SeatGrid(
                  seats: state.seats,
                  onSeatTap: (seat) => context.read<SeatsBloc>().add(
                        ToggleSeatEvent(seat),
                      ),
                ),
              ),
              const Legend(),
              Container(
                padding: const EdgeInsets.all(20),
                decoration:
                    BoxDecoration(color: Colors.white.withOpacity(0.05)),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.selectedSeats.isEmpty
                              ? 'Selecione seus assentos'
                              : '${state.selectedSeats.length} assento(s) selecionado(s)',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          if (state.selectedSeats.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Selecione pelo menos um assento'),
                              ),
                            );
                          } else {
                            context.read<CartBloc>().add(AddToCartEvent(
                                  CartItem(
                                    movie: movie,
                                    showtime: showtime,
                                    seats: state.selectedSeats,
                                  ),
                                ));
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.cart,
                              (route) => route.isFirst,
                            );
                          }
                        },
                        icon:
                            const Icon(Icons.shopping_cart_checkout, size: 20),
                        label: const Text('Continuar'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
