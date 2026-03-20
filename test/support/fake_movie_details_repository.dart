import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/data/movie_repository.dart';

/// Fake para [MovieDetailsBloc]: [getMovieDetails] e [getShowtimes], sem delay de rede.
class FakeMovieDetailsRepository extends MovieRepository {
  FakeMovieDetailsRepository({
    required this.movie,
    this.showtimes = const [],
    this.delay = Duration.zero,
    this.error,
  });

  final Movie movie;
  final List<Showtime> showtimes;
  final Duration delay;
  final Object? error;

  Future<void> _maybeDelay() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
  }

  @override
  Future<List<Movie>> getMovies() async => const [];

  @override
  Future<Movie> getMovieDetails(String movieId) async {
    await _maybeDelay();
    if (error != null) throw error!;
    return movie;
  }

  @override
  Future<List<Showtime>> getShowtimes(String movieId) async {
    await _maybeDelay();
    if (error != null) throw error!;
    return showtimes;
  }
}
