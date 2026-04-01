import 'package:cineticket/data/mocks/seat_mock.dart';
import 'package:cineticket/data/models/seat.dart';

class SeatRepository {
  Future<List<Seat>> getSeats(String showtimeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return SeatMock.seatsList;
  }
}
