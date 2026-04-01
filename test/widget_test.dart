import 'package:cineticket/core/di/di.dart';
import 'package:cineticket/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App exibe tela Filmes em Cartaz', (WidgetTester tester) async {
    setupDependencies();
    await tester.pumpWidget(const CineTicketApp());
    await tester.pump();

    expect(find.text('Filmes em Cartaz'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
