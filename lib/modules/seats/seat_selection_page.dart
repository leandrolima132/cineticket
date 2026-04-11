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
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Carregando assentos...',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
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
                    Icon(Icons.error_outline_rounded,
                        size: 64, color: AppColors.accent.withOpacity(0.9)),
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
                      icon: const Icon(Icons.refresh_rounded),
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
          appBar: AppBar(
            title: const Text('Escolha seus assentos'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: AppColors.outline.withOpacity(0.35),
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.surfaceElevated.withOpacity(0.95),
                        AppColors.surface.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.outline.withOpacity(0.45),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          movie.posterUrl,
                          width: 52,
                          height: 78,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 52,
                            height: 78,
                            color: AppColors.surface,
                            child: const Icon(Icons.movie_rounded,
                                color: AppColors.textMuted),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              showtime.theater,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.meeting_room_rounded,
                                    size: 15, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  showtime.room,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.schedule_rounded,
                                    size: 15, color: AppColors.spotlightSoft),
                                const SizedBox(width: 4),
                                Text(
                                  '${dateFormat.format(showtime.dateTime)} · ${timeFormat.format(showtime.dateTime)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.spotlightSoft,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    top: BorderSide(color: AppColors.outline.withOpacity(0.4)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.voidBlack.withOpacity(0.45),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
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
                              state.selectedSeats.isEmpty
                                  ? 'Selecione seus assentos'
                                  : '${state.selectedSeats.length} assento(s) selecionado(s)',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (state.selectedSeats.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Pinça com dois dedos para ampliar o mapa',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted.withOpacity(0.9),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () {
                          if (state.selectedSeats.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Selecione pelo menos um assento',
                                ),
                                behavior: SnackBarBehavior.floating,
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
                        icon: const Icon(Icons.confirmation_number_outlined,
                            size: 20),
                        label: const Text('Continuar'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
