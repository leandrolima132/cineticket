import 'package:cineticket/data/mocks/movie_mock.dart';
import 'package:cineticket/data/mocks/showtime_mock.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/showtime.dart';

class MovieRepository {
  Future<List<Movie>> getMovies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MovieMock.moviesList;
  }

  Future<Movie> getMovieDetails(String movieId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final movie = MovieMock.moviesList.firstWhere((m) => m.id == movieId);
    return movie;
  }

  Future<List<Showtime>> getShowtimes(String movieId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ShowtimeMock.getByMovieId(movieId);
  }
}
