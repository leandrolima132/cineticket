import 'package:cineticket/core/di/di.dart';
import 'package:cineticket/core/router/router.dart';
import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_theme.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/home/home_bloc.dart';
import 'package:cineticket/modules/home/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  setupDependencies();
  runApp(const CineTicketApp());
}

class CineTicketApp extends StatelessWidget {
  const CineTicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<HomeBloc>()..add(const LoadHomeEvent()),
        ),
        BlocProvider(create: (_) => getIt<CartBloc>()),
      ],
      child: MaterialApp(
        title: 'CineTicket',
        initialRoute: AppRoutes.auth,
        onGenerateRoute: generateRoute,
        theme: AppTheme.dark(),
      ),
    );
  }
}
