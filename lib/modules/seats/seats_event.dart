import 'package:cineticket/data/models/seat.dart';
import 'package:equatable/equatable.dart';

abstract class SeatsEvent extends Equatable {
  const SeatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSeatsEvent extends SeatsEvent {
  final String showtimeId;

  const LoadSeatsEvent(this.showtimeId);

  @override
  List<Object?> get props => [showtimeId];
}

class ToggleSeatEvent extends SeatsEvent {
  final Seat seat;

  const ToggleSeatEvent(this.seat);

  @override
  List<Object?> get props => [seat];
}
