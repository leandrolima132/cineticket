import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/seat_repository.dart';

/// Fake para [SeatsBloc] — sem delay de rede do [SeatRepository] base.
class FakeSeatRepository extends SeatRepository {
  FakeSeatRepository({
    required this.seats,
    this.delay = Duration.zero,
    this.error,
  });

  final List<Seat> seats;
  final Duration delay;
  final Object? error;

  @override
  Future<List<Seat>> getSeats(String showtimeId) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (error != null) {
      throw error!;
    }
    return seats;
  }
}
