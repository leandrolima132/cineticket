import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_state.dart';
import 'package:cineticket/modules/movies/widgets/hero_section.dart';
import 'package:cineticket/modules/movies/widgets/movie_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesListContent extends StatelessWidget {
  final List<Movie> movies;
  final VoidCallback onRefresh;
  final void Function(BuildContext context, Movie movie) onMovieTap;

  const MoviesListContent({
    super.key,
    required this.movies,
    required this.onRefresh,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    final featured = movies.firstWhere(
      (m) => m.highlight,
      orElse: () => movies.first,
    );

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: AppColors.background,
            actions: [
              BlocBuilder<CartBloc, CartState>(
                buildWhen: (p, c) => p.totalItems != c.totalItems,
                builder: (context, state) {
                  return IconButton(
                    icon: state.isEmpty
                        ? const Icon(Icons.shopping_cart_outlined)
                        : Badge(
                            label: Text('${state.totalItems}'),
                            child: const Icon(Icons.shopping_cart),
                          ),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.cart),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: HeroSection(
                movie: featured,
                onTap: () => onMovieTap(context, featured),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Em Cartaz',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MoviePosterCard(
                    movie: movie,
                    onTap: () => onMovieTap(context, movie),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
