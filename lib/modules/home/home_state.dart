import 'package:cineticket/data/models/movie.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final List<Movie>? movies;
  final bool isLoadingList;
  final String? errorMessage;

  const HomeState({
    this.movies,
    this.isLoadingList = false,
    this.errorMessage,
  });

  static const HomeState initial = HomeState();

  HomeState copyWith({
    List<Movie>? movies,
    bool? isLoadingList,
    String? errorMessage,
  }) {
    return HomeState(
      movies: movies ?? this.movies,
      isLoadingList: isLoadingList ?? this.isLoadingList,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [movies, isLoadingList, errorMessage];
}
