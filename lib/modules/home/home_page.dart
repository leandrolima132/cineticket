import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/core/widgets/logout_icon_button.dart';
import 'package:cineticket/modules/home/home_bloc.dart';
import 'package:cineticket/modules/home/home_event.dart';
import 'package:cineticket/modules/home/home_state.dart';
import 'package:cineticket/modules/home/widgets/movies_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (prev, curr) =>
            prev.movies != curr.movies ||
            prev.isLoadingList != curr.isLoadingList ||
            prev.errorMessage != curr.errorMessage,
        builder: (context, state) {
          if (state.isLoadingList) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Filmes em Cartaz'),
                actions: const [LogoutIconButton()],
              ),
              body: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Carregando filmes...',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Filmes em Cartaz'),
                actions: const [LogoutIconButton()],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 64, color: AppColors.accent),
                    const SizedBox(height: 16),
                    const Text(
                      'Erro ao carregar filmes',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
                    FilledButton.icon(
                      onPressed: () =>
                          context.read<HomeBloc>().add(const LoadHomeEvent()),
                      icon: const Icon(Icons.refresh_rounded),
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
                appBar: AppBar(
                  title: const Text('Filmes em Cartaz'),
                  actions: const [LogoutIconButton()],
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.movie_filter_rounded,
                            size: 80, color: AppColors.textMuted),
                        const SizedBox(height: 24),
                        Text(
                          'Nenhum filme em cartaz no momento',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () => context
                              .read<HomeBloc>()
                              .add(const LoadHomeEvent()),
                          icon: const Icon(Icons.refresh_rounded),
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
                  context.read<HomeBloc>().add(const LoadHomeEvent()),
              onMovieTap: (context, movie) => Navigator.pushNamed(
                context,
                AppRoutes.movieDetails,
                arguments: movie.id,
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Filmes em Cartaz'),
              actions: const [LogoutIconButton()],
            ),
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Carregando...',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 16),
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
