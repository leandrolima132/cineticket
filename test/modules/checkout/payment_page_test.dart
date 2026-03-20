import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_event.dart';
import 'package:cineticket/modules/checkout/payment_page.dart';
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
    id: 'pay-m',
    title: 'Filme Pagamento',
    description: 'd',
    posterUrl: 'https://example.com/p.jpg',
    duration: '95 min',
    genres: 'P',
    rating: '8',
    releaseDate: '2024-03-03',
  );

  final showtime = Showtime(
    id: 'pay-st',
    movieId: 'pay-m',
    theater: 'Cine Pay',
    room: 'Sala 1',
    dateTime: DateTime(2024, 9, 1, 16, 0),
    availableSeats: 20,
  );

  final cartItem = CartItem(
    movie: movie,
    showtime: showtime,
    seats: const [
      Seat(id: 's1', row: 'E', number: 1),
    ],
  );

  Widget _paymentUnderTest(CartBloc cartBloc) {
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
        value: cartBloc,
        child: const PaymentPage(),
      ),
    );
  }

  testWidgets('carrinho vazio exibe EmptyCartState', (tester) async {
    await tester.pumpWidget(_paymentUnderTest(CartBloc()));
    await tester.pumpAndSettle();

    expect(find.text('Pagamento'), findsOneWidget);
    expect(find.text('Carrinho vazio'), findsOneWidget);
    expect(find.text('Voltar ao carrinho'), findsOneWidget);
  });

  testWidgets('com itens exibe resumo e formulário de pagamento', (tester) async {
    final bloc = CartBloc()..add(AddToCartEvent(cartItem));

    await tester.pumpWidget(_paymentUnderTest(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Resumo do pedido'), findsOneWidget);
    expect(find.text('Filme Pagamento'), findsOneWidget);
    expect(find.text('Dados do cartão'), findsOneWidget);
    expect(find.text('Pagar'), findsOneWidget);
  });
}
