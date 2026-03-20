import 'package:bloc_test/bloc_test.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/movie-details/movie_details_bloc.dart';
import 'package:cineticket/modules/movie-details/movie_details_event.dart';
import 'package:cineticket/modules/movie-details/movie_details_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_movie_details_repository.dart';

void main() {
  const testMovie = Movie(
    id: 'md1',
    title: 'Detalhes Teste',
    description: 'Uma sinopse de teste para o filme.',
    posterUrl: 'https://example.com/p.jpg',
    duration: '120 min',
    genres: 'Ação, Drama',
    rating: '8.5',
    releaseDate: '2024-06-15',
  );

  final testShowtime = Showtime(
    id: 'st1',
    movieId: 'md1',
    theater: 'Cinema Unit',
    room: 'Sala 1',
    dateTime: DateTime(2024, 6, 15, 19, 30),
    availableSeats: 40,
  );

  group('MovieDetailsBloc', () {
    test('estado inicial', () {
      final bloc = MovieDetailsBloc(
        movieRepository: FakeMovieDetailsRepository(
          movie: testMovie,
          showtimes: [testShowtime],
        ),
      );
      expect(bloc.state, const MovieDetailsState());
      addTearDown(bloc.close);
    });

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'LoadMovieDetailsEvent: emite carregando e sucesso com filme e sessões',
      build: () => MovieDetailsBloc(
        movieRepository: FakeMovieDetailsRepository(
          movie: testMovie,
          showtimes: [testShowtime],
        ),
      ),
      act: (bloc) => bloc.add(const LoadMovieDetailsEvent('md1')),
      expect: () => [
        const MovieDetailsState(
          movie: null,
          showtimes: null,
          isLoading: true,
          errorMessage: null,
        ),
        MovieDetailsState(
          movie: testMovie,
          showtimes: [testShowtime],
          isLoading: false,
          errorMessage: null,
        ),
      ],
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'LoadMovieDetailsEvent: sucesso com lista de sessões vazia',
      build: () => MovieDetailsBloc(
        movieRepository: FakeMovieDetailsRepository(
          movie: testMovie,
          showtimes: const [],
        ),
      ),
      act: (bloc) => bloc.add(const LoadMovieDetailsEvent('md1')),
      expect: () => [
        const MovieDetailsState(
          movie: null,
          showtimes: null,
          isLoading: true,
          errorMessage: null,
        ),
        const MovieDetailsState(
          movie: testMovie,
          showtimes: [],
          isLoading: false,
          errorMessage: null,
        ),
      ],
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'LoadMovieDetailsEvent: emite erro quando getMovieDetails falha',
      build: () => MovieDetailsBloc(
        movieRepository: FakeMovieDetailsRepository(
          movie: testMovie,
          showtimes: const [],
          error: Exception('falha'),
        ),
      ),
      act: (bloc) => bloc.add(const LoadMovieDetailsEvent('md1')),
      expect: () => [
        const MovieDetailsState(
          movie: null,
          showtimes: null,
          isLoading: true,
          errorMessage: null,
        ),
        const MovieDetailsState(
          movie: null,
          showtimes: null,
          isLoading: false,
          errorMessage: 'Exception: falha',
        ),
      ],
    );
  });
}
