import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/showtime.dart';

class SeatSelectionArgs {
  final Movie movie;
  final Showtime showtime;

  const SeatSelectionArgs({required this.movie, required this.showtime});
}
