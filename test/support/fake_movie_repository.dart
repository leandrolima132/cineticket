import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/movie_repository.dart';

/// Repositório fake para testes — sem delay de rede do [MovieRepository] base.
class FakeMovieRepository extends MovieRepository {
  FakeMovieRepository._(this._getMovies);

  final Future<List<Movie>> Function() _getMovies;

  /// [delay] opcional para testes de widget enxergarem o estado intermediário.
  factory FakeMovieRepository.success(
    List<Movie> movies, {
    Duration delay = Duration.zero,
  }) =>
      FakeMovieRepository._(() async {
        if (delay > Duration.zero) {
          await Future<void>.delayed(delay);
        }
        return movies;
      });

  factory FakeMovieRepository.error(Object error) => FakeMovieRepository._(
        () async {
          throw error;
        },
      );

  @override
  Future<List<Movie>> getMovies() => _getMovies();
}
