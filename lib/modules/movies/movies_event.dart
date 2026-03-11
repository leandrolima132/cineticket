import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoviesEvent extends MoviesEvent {
  const LoadMoviesEvent();
}

class LoadMovieDetailsEvent extends MoviesEvent {
  final String movieId;

  const LoadMovieDetailsEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
