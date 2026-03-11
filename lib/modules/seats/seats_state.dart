import 'package:cineticket/data/models/seat.dart';
import 'package:equatable/equatable.dart';

class SeatsState extends Equatable {
  final List<Seat> seats;
  final bool isLoading;
  final String? errorMessage;

  const SeatsState({
    this.seats = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  List<Seat> get selectedSeats =>
      seats.where((s) => s.status == SeatStatus.selected).toList();

  SeatsState copyWith({
    List<Seat>? seats,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SeatsState(
      seats: seats ?? this.seats,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [seats, isLoading, errorMessage];
}
