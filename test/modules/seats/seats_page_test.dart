import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/seats/seat_selection_page.dart';
import 'package:cineticket/modules/seats/seats_bloc.dart';
import 'package:cineticket/modules/seats/seats_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../support/fake_seat_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  const movie = Movie(
    id: 'm1',
    title: 'Filme Assentos',
    description: 'd',
    posterUrl: 'https://example.com/p.jpg',
    duration: '100 min',
    genres: 'A',
    rating: '8',
    releaseDate: '2024-01-01',
  );

  final showtime = Showtime(
    id: 'st-page',
    movieId: 'm1',
    theater: 'Cinema Seats Test',
    room: 'Sala 3',
    dateTime: DateTime(2024, 7, 20, 20, 15),
    availableSeats: 100,
  );

  const seatFree = Seat(
    id: 'b1',
    row: 'B',
    number: 1,
    status: SeatStatus.available,
  );

  Widget _seatPageUnderTest(SeatsBloc bloc) {
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
          BlocProvider.value(value: bloc),
          BlocProvider(create: (_) => CartBloc()),
        ],
        child: SeatSelectionPage(
          movie: movie,
          showtime: showtime,
        ),
      ),
    );
  }

  testWidgets('exibe carregando e depois legenda e sessão', (tester) async {
    final bloc = SeatsBloc(
      seatRepository: FakeSeatRepository(
        seats: const [seatFree],
        delay: const Duration(milliseconds: 16),
      ),
    )..add(LoadSeatsEvent(showtime.id));

    await tester.pumpWidget(_seatPageUnderTest(bloc));
    await tester.pump();
    expect(find.text('Carregando assentos...'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Cinema Seats Test'), findsOneWidget);
    expect(find.text('Disponível'), findsOneWidget);
    expect(find.text('Selecione seus assentos'), findsOneWidget);
  });

  testWidgets('exibe erro e Tentar novamente', (tester) async {
    final bloc = SeatsBloc(
      seatRepository: FakeSeatRepository(
        seats: const [],
        error: Exception('falha'),
      ),
    )..add(LoadSeatsEvent(showtime.id));

    await tester.pumpWidget(_seatPageUnderTest(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Exception: falha'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
