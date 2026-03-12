import 'package:cineticket/data/movie_repository.dart';
import 'package:cineticket/modules/home/home_event.dart';
import 'package:cineticket/modules/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository movieRepository;

  HomeBloc({required this.movieRepository}) : super(HomeState.initial) {
    on<LoadHomeEvent>(_onLoadHome);
  }

  Future<void> _onLoadHome(
    LoadHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoadingList: true, errorMessage: null));
    try {
      final movies = await movieRepository.getMovies();
      emit(state.copyWith(
        movies: movies,
        isLoadingList: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingList: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
