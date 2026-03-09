import 'package:cineticket/core/errors/failures.dart';
import 'package:cineticket/modules/movies/data/datasources/movie_remote_datasource.dart';
import 'package:cineticket/modules/movies/domain/entities/movie.dart';
import 'package:cineticket/modules/movies/domain/entities/showtime.dart';
import 'package:cineticket/modules/movies/domain/repositories/movie_repository.dart';
import 'package:dartz/dartz.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getMoviesInTheater() async {
    try {
      final movies = await remoteDataSource.getMoviesInTheater();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(String movieId) async {
    try {
      final movie = await remoteDataSource.getMovieDetails(movieId);
      return Right(movie);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Showtime>>> getMovieShowtimes(
      String movieId) async {
    try {
      final showtimes = await remoteDataSource.getMovieShowtimes(movieId);
      return Right(showtimes);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
