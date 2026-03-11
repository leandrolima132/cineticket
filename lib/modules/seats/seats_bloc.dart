import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/seat_repository.dart';
import 'package:cineticket/modules/seats/seats_event.dart';
import 'package:cineticket/modules/seats/seats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeatsBloc extends Bloc<SeatsEvent, SeatsState> {
  final SeatRepository seatRepository;

  SeatsBloc({required this.seatRepository}) : super(const SeatsState()) {
    on<LoadSeatsEvent>(_onLoadSeats);
    on<ToggleSeatEvent>(_onToggleSeat);
  }

  Future<void> _onLoadSeats(
    LoadSeatsEvent event,
    Emitter<SeatsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final seats = await seatRepository.getSeats(event.showtimeId);
      emit(state.copyWith(seats: seats, isLoading: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onToggleSeat(
    ToggleSeatEvent event,
    Emitter<SeatsState> emit,
  ) {
    if (event.seat.status == SeatStatus.occupied) return;
    final updatedSeats = state.seats.map((s) {
      if (s.id == event.seat.id) {
        return s.copyWith(
          status: s.status == SeatStatus.selected
              ? SeatStatus.available
              : SeatStatus.selected,
        );
      }
      return s;
    }).toList();
    emit(state.copyWith(seats: updatedSeats));
  }
}
