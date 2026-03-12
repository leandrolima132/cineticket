import 'package:cineticket/core/di/di.dart';
import 'package:cineticket/core/router/router.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/home/home_bloc.dart';
import 'package:cineticket/modules/home/home_event.dart';
import 'package:cineticket/modules/home/home_page.dart';
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
        onGenerateRoute: generateRoute,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            secondary: Colors.redAccent,
            surface: AppColors.background,
            error: Colors.redAccent,
            onPrimary: Colors.black,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onError: Colors.white,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
