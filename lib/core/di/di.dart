import 'package:cineticket/data/movie_repository.dart';
import 'package:cineticket/data/seat_repository.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/home/home_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<MovieRepository>(() => MovieRepository());
  getIt.registerLazySingleton<SeatRepository>(() => SeatRepository());
  getIt.registerLazySingleton<HomeBloc>(
    () => HomeBloc(movieRepository: getIt()),
  );
  getIt.registerLazySingleton<CartBloc>(() => CartBloc());
}
