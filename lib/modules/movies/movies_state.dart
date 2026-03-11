import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:equatable/equatable.dart';

class MoviesState extends Equatable {
  final List<Movie>? movies;
  final Movie? selectedMovie;
  final List<Showtime>? showtimes;
  final bool isLoadingList;
  final bool isLoadingDetails;
  final String? errorMessage;

  const MoviesState({
    this.movies,
    this.selectedMovie,
    this.showtimes,
    this.isLoadingList = false,
    this.isLoadingDetails = false,
    this.errorMessage,
  });

  static const MoviesState initial = MoviesState();

  MoviesState copyWith({
    List<Movie>? movies,
    Movie? selectedMovie,
    List<Showtime>? showtimes,
    bool? isLoadingList,
    bool? isLoadingDetails,
    String? errorMessage,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      selectedMovie: selectedMovie ?? this.selectedMovie,
      showtimes: showtimes ?? this.showtimes,
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [movies, selectedMovie, showtimes, isLoadingList, isLoadingDetails, errorMessage];
}
