import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/core/widgets/logout_icon_button.dart';
import 'package:cineticket/core/widgets/streaming_section_header.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_state.dart';
import 'package:cineticket/modules/home/widgets/hero_section.dart';
import 'package:cineticket/modules/home/widgets/movie_poster_card.dart';
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
      color: AppColors.accent,
      backgroundColor: AppColors.surfaceElevated,
      displacement: 48,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 440,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            actions: [
              const LogoutIconButton(),
              BlocBuilder<CartBloc, CartState>(
                buildWhen: (p, c) => p.totalItems != c.totalItems,
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor:
                            AppColors.surfaceElevated.withOpacity(0.55),
                      ),
                      icon: state.isEmpty
                          ? const Icon(Icons.shopping_bag_outlined)
                          : Badge(
                              backgroundColor: AppColors.accent,
                              label: Text(
                                '${state.totalItems}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Icon(
                                  Icons.confirmation_number_outlined),
                            ),
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.cart),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
              background: HeroSection(
                movie: featured,
                onTap: () => onMovieTap(context, featured),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 28, 16, 0),
              child: StreamingSectionHeader(
                overline: 'Agora no cinema',
                title: 'Em Cartaz',
                subtitle: 'Deslize e escolha o próximo filme',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 304,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
