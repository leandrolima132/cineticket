import 'package:cineticket/core/di/di.dart';
import 'package:cineticket/core/router/receipt_args.dart';
import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/router/seat_selection_args.dart';
import 'package:cineticket/data/movie_repository.dart';
import 'package:cineticket/data/seat_repository.dart';
import 'package:cineticket/modules/auth/auth_page.dart';
import 'package:cineticket/modules/cart/cart_page.dart';
import 'package:cineticket/modules/checkout/payment_page.dart';
import 'package:cineticket/modules/checkout/receipt_page.dart';
import 'package:cineticket/modules/home/home_page.dart';
import 'package:cineticket/modules/movie-details/movie_details_bloc.dart';
import 'package:cineticket/modules/movie-details/movie_details_event.dart';
import 'package:cineticket/modules/movie-details/movie_details_page.dart';
import 'package:cineticket/modules/seats/seat_selection_page.dart';
import 'package:cineticket/modules/seats/seats_bloc.dart';
import 'package:cineticket/modules/seats/seats_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.auth:
      return MaterialPageRoute(builder: (_) => const AuthPage());
    case AppRoutes.movies:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case AppRoutes.movieDetails:
      final movieId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => MovieDetailsBloc(
            movieRepository: getIt<MovieRepository>(),
          )..add(LoadMovieDetailsEvent(movieId)),
          child: MovieDetailsPage(movieId: movieId),
        ),
      );
    case AppRoutes.seatSelection:
      final args = settings.arguments as SeatSelectionArgs;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) =>
              SeatsBloc(seatRepository: getIt<SeatRepository>())
                ..add(LoadSeatsEvent(args.showtime.id)),
          child: SeatSelectionPage(
            movie: args.movie,
            showtime: args.showtime,
          ),
        ),
      );
    case AppRoutes.cart:
      return MaterialPageRoute(builder: (_) => const CartPage());
    case AppRoutes.payment:
      return MaterialPageRoute(builder: (_) => const PaymentPage());
    case AppRoutes.receipt:
      final args = settings.arguments as ReceiptArgs;
      return MaterialPageRoute(
        builder: (_) => const ReceiptPage(),
        settings: RouteSettings(name: settings.name, arguments: args),
      );
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
