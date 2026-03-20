import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/home/home_bloc.dart';
import 'package:cineticket/modules/home/home_event.dart';
import 'package:cineticket/modules/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_movie_repository.dart';

Widget _homeUnderTest(HomeBloc homeBloc) {
  return MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.redAccent,
        surface: AppColors.background,
      ),
    ),
    home: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeBloc),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: const HomePage(),
    ),
  );
}

void main() {
  const movie = Movie(
    id: 'hp1',
    title: 'Home Page Filme',
    description: 'd',
    posterUrl: 'https://example.com/x.jpg',
    duration: '100 min',
    genres: 'A',
    rating: '8.0',
    releaseDate: '2024-01-01',
    highlight: true,
  );

  testWidgets('exibe carregamento e depois seção Em Cartaz com filme',
      (tester) async {
    final bloc = HomeBloc(
      movieRepository: FakeMovieRepository.success(
        const [movie],
        delay: const Duration(milliseconds: 16),
      ),
    )..add(const LoadHomeEvent());

    await tester.pumpWidget(_homeUnderTest(bloc));
    await tester.pump();
    expect(find.text('Carregando filmes...'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Em Cartaz'), findsOneWidget);
    expect(find.text('Home Page Filme'), findsWidgets);
  });

  testWidgets('exibe estado de erro e botão Tentar novamente', (tester) async {
    final bloc = HomeBloc(
      movieRepository: FakeMovieRepository.error(Exception('erro')),
    )..add(const LoadHomeEvent());

    await tester.pumpWidget(_homeUnderTest(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Erro ao carregar filmes'), findsOneWidget);
    expect(find.text('Exception: erro'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });

  testWidgets('exibe estado vazio quando não há filmes', (tester) async {
    final bloc = HomeBloc(
      movieRepository: FakeMovieRepository.success(const []),
    )..add(const LoadHomeEvent());

    await tester.pumpWidget(_homeUnderTest(bloc));
    await tester.pumpAndSettle();

    expect(
      find.text('Nenhum filme em cartaz no momento'),
      findsOneWidget,
    );
    expect(find.text('Atualizar'), findsOneWidget);
  });
}
