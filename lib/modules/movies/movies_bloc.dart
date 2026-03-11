import 'package:cineticket/data/movie_repository.dart';
import 'package:cineticket/modules/movies/movies_event.dart';
import 'package:cineticket/modules/movies/movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MovieRepository movieRepository;

  MoviesBloc({required this.movieRepository}) : super(MoviesState.initial) {
    on<LoadMoviesEvent>(_onLoadMovies);
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
  }

  Future<void> _onLoadMovies(
      LoadMoviesEvent event, Emitter<MoviesState> emit) async {
    emit(state.copyWith(isLoadingList: true, errorMessage: null));
    try {
      final movies = await movieRepository.getMovies();
      emit(state.copyWith(
          movies: movies, isLoadingList: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
        isLoadingList: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingDetails: true,
      errorMessage: null,
      selectedMovie: null,
      showtimes: null,
    ));
    try {
      final movie = await movieRepository.getMovieDetails(event.movieId);
      final showtimes = await movieRepository.getShowtimes(event.movieId);
      emit(state.copyWith(
        selectedMovie: movie,
        showtimes: showtimes,
        isLoadingDetails: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingDetails: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
