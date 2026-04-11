import 'package:cineticket/core/di/di.dart';
import 'package:cineticket/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App abre login e após entrar exibe a home com Em Cartaz',
      (WidgetTester tester) async {
    setupDependencies();
    await tester.pumpWidget(const CineTicketApp());
    await tester.pump();

    expect(find.text('CineTicket'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'secret123',
    );
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Em Cartaz'), findsOneWidget);
  });
}
