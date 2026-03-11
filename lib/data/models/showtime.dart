import 'package:equatable/equatable.dart';

class Showtime extends Equatable {
  final String id;
  final String movieId;
  final String theater;
  final String room;
  final DateTime dateTime;
  final int availableSeats;

  const Showtime({
    required this.id,
    required this.movieId,
    required this.theater,
    required this.room,
    required this.dateTime,
    required this.availableSeats,
  });

  @override
  List<Object?> get props => [id, movieId, theater, room, dateTime, availableSeats];
}
