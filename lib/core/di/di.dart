import 'package:cineticket/data/movie_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<MovieRepository>(() => MovieRepository());
}
