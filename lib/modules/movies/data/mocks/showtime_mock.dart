import 'package:cineticket/modules/movies/domain/entities/showtime.dart';

class ShowtimeMock {
  static Showtime get showtime1 => Showtime(
        id: '1',
        movieId: '1',
        theater: 'Cinema Central',
        room: 'Sala 1',
        dateTime: DateTime(2024, 12, 20, 14, 30),
        availableSeats: 45,
      );

  static Showtime get showtime2 => Showtime(
        id: '2',
        movieId: '1',
        theater: 'Cinema Central',
        room: 'Sala 2',
        dateTime: DateTime(2024, 12, 20, 17, 0),
        availableSeats: 30,
      );

  static Showtime get showtime3 => Showtime(
        id: '3',
        movieId: '1',
        theater: 'Cinema Central',
        room: 'Sala 3',
        dateTime: DateTime(2024, 12, 20, 20, 30),
        availableSeats: 15,
      );

  static Showtime get showtime4 => Showtime(
        id: '4',
        movieId: '2',
        theater: 'Cinema Premium',
        room: 'Sala VIP',
        dateTime: DateTime(2024, 12, 21, 15, 0),
        availableSeats: 20,
      );

  static Showtime get showtime5 => Showtime(
        id: '5',
        movieId: '2',
        theater: 'Cinema Premium',
        room: 'Sala VIP',
        dateTime: DateTime(2024, 12, 21, 18, 30),
        availableSeats: 25,
      );

  static List<Showtime> get showtimesList => [
        showtime1,
        showtime2,
        showtime3,
        showtime4,
        showtime5,
      ];

  static List<Showtime> getShowtimesByMovieId(String movieId) {
    return showtimesList
        .where((showtime) => showtime.movieId == movieId)
        .toList();
  }
}
