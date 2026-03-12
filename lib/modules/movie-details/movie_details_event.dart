import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovieDetailsEvent extends MovieDetailsEvent {
  final String movieId;

  const LoadMovieDetailsEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
