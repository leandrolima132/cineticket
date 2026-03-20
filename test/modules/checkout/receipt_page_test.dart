import 'package:cineticket/core/router/receipt_args.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/checkout/constants.dart';
import 'package:cineticket/modules/checkout/receipt_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  const movie = Movie(
    id: 'rec-m',
    title: 'Filme Comprovante',
    description: 'd',
    posterUrl: 'https://example.com/r.jpg',
    duration: '88 min',
    genres: 'R',
    rating: '9',
    releaseDate: '2024-04-04',
  );

  final showtime = Showtime(
    id: 'rec-st',
    movieId: 'rec-m',
    theater: 'Cine Recibo',
    room: 'Sala 2',
    dateTime: DateTime(2024, 10, 10, 19, 30),
    availableSeats: 15,
  );

  final cartItem = CartItem(
    movie: movie,
    showtime: showtime,
    seats: const [
      Seat(id: 'r1', row: 'F', number: 1),
      Seat(id: 'r2', row: 'F', number: 2),
    ],
  );

  ReceiptArgs _args({Map<int, int>? halfPricePerItem}) {
    return ReceiptArgs(
      items: [cartItem],
      halfPricePerItem: halfPricePerItem ?? const {},
    );
  }

  Future<void> _pumpReceipt(
    WidgetTester tester,
    ReceiptArgs args,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            secondary: Colors.redAccent,
            surface: AppColors.background,
          ),
        ),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      settings: RouteSettings(arguments: args),
                      builder: (_) => BlocProvider(
                        create: (_) => CartBloc(),
                        child: const ReceiptPage(),
                      ),
                    ),
                  );
                },
                child: const Text('abrir'),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  testWidgets('exibe sucesso, filme e total coerente com PaymentConstants',
      (tester) async {
    await _pumpReceipt(tester, _args(halfPricePerItem: {0: 1}));

    expect(find.text('Comprovante'), findsOneWidget);
    expect(find.text('Pagamento realizado com sucesso!'), findsOneWidget);
    expect(find.text('Filme Comprovante'), findsOneWidget);
    expect(find.text('Total pago'), findsOneWidget);

    final expected = PaymentConstants.calculateSubtotal(2, 1);
    final formatted = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(expected);
    expect(find.text(formatted), findsWidgets);
  });

  testWidgets('exibe Voltar ao início', (tester) async {
    await _pumpReceipt(tester, _args());

    expect(find.text('Voltar ao início'), findsOneWidget);
  });
}
