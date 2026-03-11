import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/mocks/seat_mock.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_event.dart';
import 'package:cineticket/modules/seats/widgets/legend.dart';
import 'package:cineticket/modules/seats/widgets/seat_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SeatSelectionPage extends StatefulWidget {
  final Movie movie;
  final Showtime showtime;

  const SeatSelectionPage(
      {super.key, required this.movie, required this.showtime});

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  List<Seat> _seats = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSeats();
  }

  Future<void> _loadSeats() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      setState(() {
        _seats = SeatMock.seatsList;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _toggleSeat(Seat seat) {
    if (seat.status == SeatStatus.occupied) return;
    setState(() {
      _seats = _seats.map((s) {
        if (s.id == seat.id) {
          return s.copyWith(
            status: s.status == SeatStatus.selected
                ? SeatStatus.available
                : SeatStatus.selected,
          );
        }
        return s;
      }).toList();
    });
  }

  List<Seat> get _selectedSeats =>
      _seats.where((s) => s.status == SeatStatus.selected).toList();

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM');

    if (_loading) {
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

    if (_error != null) {
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
                  _error!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _loadSeats,
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
                          widget.showtime.theater,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${widget.showtime.room} • ${dateFormat.format(widget.showtime.dateTime)} ${timeFormat.format(widget.showtime.dateTime)}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[400]),
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
              seats: _seats,
              onSeatTap: _toggleSeat,
            ),
          ),
          const Legend(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedSeats.isEmpty
                          ? 'Selecione seus assentos'
                          : '${_selectedSeats.length} assento(s) selecionado(s)',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      if (_selectedSeats.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Selecione pelo menos um assento')),
                        );
                      } else {
                        context.read<CartBloc>().add(AddToCartEvent(CartItem(
                            movie: widget.movie,
                            showtime: widget.showtime,
                            seats: _selectedSeats)));
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.cart,
                          (route) => route.isFirst,
                        );
                      }
                    },
                    icon: const Icon(Icons.shopping_cart_checkout, size: 20),
                    label: const Text('Continuar'),
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
