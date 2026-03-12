import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final Movie movie;
  final Showtime showtime;
  final List<Seat> seats;

  const CartItem({
    required this.movie,
    required this.showtime,
    required this.seats,
  });

  String get seatsLabel => seats.map((s) => s.label).join(', ');
  int get totalTickets => seats.length;

  @override
  List<Object?> get props => [movie.id, showtime.id, seats];
}
