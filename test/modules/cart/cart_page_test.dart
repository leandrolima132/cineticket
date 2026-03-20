import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_event.dart';
import 'package:cineticket/modules/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  const movie = Movie(
    id: 'page-cart',
    title: 'Título no Carrinho',
    description: 'd',
    posterUrl: 'https://example.com/x.jpg',
    duration: '100 min',
    genres: 'G',
    rating: '8',
    releaseDate: '2024-02-02',
  );

  final showtime = Showtime(
    id: 'st-cart',
    movieId: 'page-cart',
    theater: 'Multiplex Test',
    room: 'Sala 5',
    dateTime: DateTime(2024, 8, 12, 21, 45),
    availableSeats: 40,
  );

  const seats = [
    Seat(id: 'p1', row: 'D', number: 1),
    Seat(id: 'p2', row: 'D', number: 2),
  ];

  final cartItem = CartItem(
    movie: movie,
    showtime: showtime,
    seats: seats,
  );

  Widget _cartUnderTest(CartBloc bloc) {
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
        child: const CartPage(),
      ),
    );
  }

  testWidgets('carrinho vazio exibe mensagem e Ver filmes', (tester) async {
    await tester.pumpWidget(_cartUnderTest(CartBloc()));
    await tester.pumpAndSettle();

    expect(find.text('Carrinho'), findsOneWidget);
    expect(find.text('Seu carrinho está vazio'), findsOneWidget);
    expect(
      find.text('Selecione assentos em uma sessão para adicionar ingressos.'),
      findsOneWidget,
    );
    expect(find.text('Ver filmes'), findsOneWidget);
  });

  testWidgets('carrinho com itens exibe filme, total e Finalizar compra',
      (tester) async {
    final bloc = CartBloc()..add(AddToCartEvent(cartItem));

    await tester.pumpWidget(_cartUnderTest(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Título no Carrinho'), findsOneWidget);
    expect(find.text('2 ingresso(s)'), findsOneWidget);
    expect(find.text('Finalizar compra'), findsOneWidget);
    expect(find.text('Multiplex Test • Sala 5'), findsOneWidget);
  });
}
