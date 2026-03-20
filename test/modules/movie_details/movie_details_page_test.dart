import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/movie-details/movie_details_bloc.dart';
import 'package:cineticket/modules/movie-details/movie_details_event.dart';
import 'package:cineticket/modules/movie-details/movie_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../support/fake_movie_details_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  const movie = Movie(
    id: 'page1',
    title: 'Página Detalhes',
    description: 'Descrição curta.',
    posterUrl: 'https://example.com/x.jpg',
    duration: '99 min',
    genres: 'Teste',
    rating: '7.0',
    releaseDate: '2024-03-10',
  );

  final showtime = Showtime(
    id: 's1',
    movieId: 'page1',
    theater: 'Cinema Widget',
    room: 'Sala A',
    dateTime: DateTime(2024, 8, 1, 21, 0),
    availableSeats: 12,
  );

  Widget detailsUnderTest(MovieDetailsBloc bloc) {
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
      home: BlocProvider.value(
        value: bloc,
        child: const MovieDetailsPage(movieId: 'page1'),
      ),
    );
  }

  testWidgets('exibe carregando e depois título e horários', (tester) async {
    final bloc = MovieDetailsBloc(
      movieRepository: FakeMovieDetailsRepository(
        movie: movie,
        showtimes: [showtime],
        delay: const Duration(milliseconds: 16),
      ),
    )..add(const LoadMovieDetailsEvent('page1'));

    await tester.pumpWidget(detailsUnderTest(bloc));
    await tester.pump();
    expect(find.text('Carregando detalhes...'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Página Detalhes'), findsWidgets);
    expect(find.text('Horários de Exibição'), findsOneWidget);
    expect(find.text('Cinema Widget'), findsOneWidget);
  });

  testWidgets('exibe erro e Tentar novamente', (tester) async {
    final bloc = MovieDetailsBloc(
      movieRepository: FakeMovieDetailsRepository(
        movie: movie,
        showtimes: const [],
        error: Exception('erro rede'),
      ),
    )..add(const LoadMovieDetailsEvent('page1'));

    await tester.pumpWidget(detailsUnderTest(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Erro ao carregar detalhes'), findsOneWidget);
    expect(find.text('Exception: erro rede'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });

  testWidgets('sem sessões: mensagem de lista vazia', (tester) async {
    final bloc = MovieDetailsBloc(
      movieRepository: FakeMovieDetailsRepository(
        movie: movie,
        showtimes: const [],
      ),
    )..add(const LoadMovieDetailsEvent('page1'));

    await tester.pumpWidget(detailsUnderTest(bloc));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Nenhum horário disponível para este filme no momento.',
      ),
      findsOneWidget,
    );
  });
}
