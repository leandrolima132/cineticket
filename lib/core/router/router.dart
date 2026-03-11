import 'package:cineticket/core/di/di.dart';
import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/modules/movies/movie_details_page.dart';
import 'package:cineticket/modules/movies/movies_bloc.dart';
import 'package:cineticket/modules/movies/movies_event.dart';
import 'package:cineticket/modules/movies/movies_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.movies:
      return MaterialPageRoute(builder: (_) => const MoviesPage());
    case AppRoutes.movieDetails:
      final movieId = settings.arguments as String;
      getIt<MoviesBloc>().add(LoadMovieDetailsEvent(movieId));
      return MaterialPageRoute(
        builder: (_) => MovieDetailsPage(movieId: movieId),
      );

    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
