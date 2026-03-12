import 'package:cineticket/data/movie_repository.dart';
import 'package:cineticket/modules/movie-details/movie_details_event.dart';
import 'package:cineticket/modules/movie-details/movie_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieRepository movieRepository;

  MovieDetailsBloc({required this.movieRepository})
      : super(const MovieDetailsState()) {
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final movie = await movieRepository.getMovieDetails(event.movieId);
      final showtimes = await movieRepository.getShowtimes(event.movieId);
      emit(state.copyWith(
        movie: movie,
        showtimes: showtimes,
        isLoading: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
