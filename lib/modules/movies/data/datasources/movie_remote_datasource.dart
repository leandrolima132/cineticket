import 'dart:async';

import 'package:cineticket/modules/movies/data/mocks/movie_mock.dart';
import 'package:cineticket/modules/movies/data/mocks/showtime_mock.dart';
import 'package:cineticket/modules/movies/domain/entities/movie.dart';
import 'package:cineticket/modules/movies/domain/entities/showtime.dart';

abstract class MovieRemoteDataSource {
  Future<List<Movie>> getMoviesInTheater();
  Future<Movie> getMovieDetails(String movieId);
  Future<List<Showtime>> getMovieShowtimes(String movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const Duration _networkDelay = Duration(milliseconds: 1500);

  @override
  Future<List<Movie>> getMoviesInTheater() async {
    await Future.delayed(_networkDelay);

    // if (Random().nextBool()) {
    //   throw ServerException(message: 'Server error occurred');
    // }

    return MovieMock.moviesList;
  }

  @override
  Future<Movie> getMovieDetails(String movieId) async {
    // Simula latência de rede
    await Future.delayed(_networkDelay);

    final movie = MovieMock.moviesList.firstWhere(
      (movie) => movie.id == movieId,
      orElse: () => throw Exception('Movie not found'),
    );

    return movie;
  }

  @override
  Future<List<Showtime>> getMovieShowtimes(String movieId) async {
    await Future.delayed(_networkDelay);
    // if (Random().nextBool()) {
    //   throw ServerException(message: 'Server error occurred');
    // }
    return ShowtimeMock.getShowtimesByMovieId(movieId);
  }
}
