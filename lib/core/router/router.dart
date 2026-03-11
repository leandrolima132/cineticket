import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/modules/movies/movies_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.movies:
      return MaterialPageRoute(builder: (_) => const MoviesPage());

    default:
      return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
