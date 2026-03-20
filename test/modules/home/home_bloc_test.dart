import 'package:bloc_test/bloc_test.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/modules/home/home_bloc.dart';
import 'package:cineticket/modules/home/home_event.dart';
import 'package:cineticket/modules/home/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_movie_repository.dart';

void main() {
  const testMovie = Movie(
    id: 't1',
    title: 'Filme Teste',
    description: 'desc',
    posterUrl: 'https://example.com/poster.jpg',
    duration: '120 min',
    genres: 'Test',
    rating: '9.0',
    releaseDate: '2020-01-01',
    highlight: true,
  );

  group('HomeBloc', () {
    test('estado inicial', () {
      final bloc = HomeBloc(
        movieRepository: FakeMovieRepository.success(const [testMovie]),
      );
      expect(bloc.state, HomeState.initial);
      addTearDown(bloc.close);
    });

    blocTest<HomeBloc, HomeState>(
      'LoadHomeEvent: emite carregando e depois sucesso com filmes',
      build: () => HomeBloc(
        movieRepository: FakeMovieRepository.success(const [testMovie]),
      ),
      act: (bloc) => bloc.add(const LoadHomeEvent()),
      expect: () => [
        const HomeState(
          movies: null,
          isLoadingList: true,
          errorMessage: null,
        ),
        const HomeState(
          movies: [testMovie],
          isLoadingList: false,
          errorMessage: null,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'LoadHomeEvent: lista vazia mantém sucesso com movies == []',
      build: () => HomeBloc(
        movieRepository: FakeMovieRepository.success(const []),
      ),
      act: (bloc) => bloc.add(const LoadHomeEvent()),
      expect: () => [
        const HomeState(
          movies: null,
          isLoadingList: true,
          errorMessage: null,
        ),
        const HomeState(
          movies: [],
          isLoadingList: false,
          errorMessage: null,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'LoadHomeEvent: emite carregando e erro quando getMovies falha',
      build: () => HomeBloc(
        movieRepository: FakeMovieRepository.error(Exception('falha de rede')),
      ),
      act: (bloc) => bloc.add(const LoadHomeEvent()),
      expect: () => [
        const HomeState(
          movies: null,
          isLoadingList: true,
          errorMessage: null,
        ),
        const HomeState(
          movies: null,
          isLoadingList: false,
          errorMessage: 'Exception: falha de rede',
        ),
      ],
    );
  });
}
