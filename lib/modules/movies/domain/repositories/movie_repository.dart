import 'package:cineticket/core/errors/failures.dart';
import 'package:cineticket/modules/movies/domain/entities/movie.dart';
import 'package:cineticket/modules/movies/domain/entities/showtime.dart';
import 'package:dartz/dartz.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMoviesInTheater();
  Future<Either<Failure, Movie>> getMovieDetails(String movieId);
  Future<Either<Failure, List<Showtime>>> getMovieShowtimes(String movieId);
}
