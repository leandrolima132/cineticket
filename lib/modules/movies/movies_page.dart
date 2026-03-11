import 'package:cineticket/modules/movies/movies_bloc.dart';
import 'package:cineticket/modules/movies/movies_event.dart';
import 'package:cineticket/modules/movies/movies_state.dart';
import 'package:cineticket/modules/movies/widgets/movies_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoviesBloc, MoviesState>(
        buildWhen: (prev, curr) =>
            prev.movies != curr.movies ||
            prev.isLoadingList != curr.isLoadingList ||
            prev.errorMessage != curr.errorMessage,
        builder: (context, state) {
          if (state.isLoadingList) {
            return Scaffold(
              appBar: AppBar(title: const Text('Filmes em Cartaz')),
              body: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Carregando filmes...',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Filmes em Cartaz')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar filmes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<MoviesBloc>()
                          .add(const LoadMoviesEvent()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final movies = state.movies;
          if (movies != null) {
            if (movies.isEmpty) {
              return Scaffold(
                appBar: AppBar(title: const Text('Filmes em Cartaz')),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie_outlined,
                            size: 80, color: Colors.grey[600]),
                        const SizedBox(height: 24),
                        Text(
                          'Nenhum filme em cartaz no momento',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () => context
                              .read<MoviesBloc>()
                              .add(const LoadMoviesEvent()),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Atualizar'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return MoviesListContent(
                movies: movies,
                onRefresh: () =>
                    context.read<MoviesBloc>().add(const LoadMoviesEvent()),
                onMovieTap: (context, movie) => {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filme selecionado')),
                      )
                    });
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Filmes em Cartaz')),
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Carregando...',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
