import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:equatable/equatable.dart';

class MovieDetailsState extends Equatable {
  final Movie? movie;
  final List<Showtime>? showtimes;
  final bool isLoading;
  final String? errorMessage;

  const MovieDetailsState({
    this.movie,
    this.showtimes,
    this.isLoading = false,
    this.errorMessage,
  });

  MovieDetailsState copyWith({
    Movie? movie,
    List<Showtime>? showtimes,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MovieDetailsState(
      movie: movie ?? this.movie,
      showtimes: showtimes ?? this.showtimes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [movie, showtimes, isLoading, errorMessage];
}
