import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/router/seat_selection_args.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/core/utils/utils.dart';
import 'package:cineticket/modules/home/widgets/hero_section.dart';
import 'package:cineticket/modules/movie-details/movie_details_bloc.dart';
import 'package:cineticket/modules/movie-details/movie_details_event.dart';
import 'package:cineticket/modules/movie-details/movie_details_state.dart';
import 'package:cineticket/modules/movie-details/widgets/showtime_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsPage extends StatefulWidget {
  final String movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        buildWhen: (prev, curr) =>
            prev.movie != curr.movie ||
            prev.showtimes != curr.showtimes ||
            prev.isLoading != curr.isLoading ||
            prev.errorMessage != curr.errorMessage,
        builder: (context, state) {
          if (state.isLoading) {
            return Scaffold(
              appBar: AppBar(title: const Text('Detalhes do filme')),
              body: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Carregando detalhes...',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Detalhes do filme')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        'Erro ao carregar detalhes',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {
                          context
                              .read<MovieDetailsBloc>()
                              .add(LoadMovieDetailsEvent(widget.movieId));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final movie = state.movie;
          final showtimes = state.showtimes ?? [];
          if (movie != null) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 450,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  flexibleSpace: HeroSection(movie: movie),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _InfoChip(
                                icon: Icons.star,
                                label: movie.rating,
                                color: Colors.amber),
                            const SizedBox(width: 12),
                            _InfoChip(
                                icon: Icons.access_time,
                                label: movie.duration,
                                color: Colors.grey),
                            const SizedBox(width: 12),
                            _InfoChip(
                              icon: Icons.calendar_today,
                              label: formatDateToBr(movie.releaseDate),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: movie.genres.split(', ').map((genre) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                genre,
                                style: TextStyle(
                                    color: Colors.grey[300], fontSize: 13),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        _ExpandableSynopsis(description: movie.description),
                        const SizedBox(height: 32),
                        Text(
                          'Horários de Exibição',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: showtimes.isEmpty
                              ? [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      child: Text(
                                        'Nenhum horário disponível para este filme no momento.',
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 15),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ]
                              : showtimes
                                  .map((showtime) => ShowtimeCard(
                                        showtime: showtime,
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.seatSelection,
                                            arguments: SeatSelectionArgs(
                                              movie: movie,
                                              showtime: showtime,
                                            ),
                                          );
                                        },
                                      ))
                                  .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Detalhes do filme')),
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

class _ExpandableSynopsis extends StatefulWidget {
  final String description;

  const _ExpandableSynopsis({required this.description});

  @override
  State<_ExpandableSynopsis> createState() => _ExpandableSynopsisState();
}

class _ExpandableSynopsisState extends State<_ExpandableSynopsis> {
  static const int _maxLinesCollapsed = 3;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final showToggle = widget.description.length > 120;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sinopse',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.description,
          style: TextStyle(color: Colors.grey[300], fontSize: 15, height: 1.5),
          maxLines: _expanded ? null : _maxLinesCollapsed,
          overflow: _expanded ? null : TextOverflow.ellipsis,
        ),
        if (showToggle)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? 'Ver menos' : 'Ver mais',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final MaterialColor color;

  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color[400]),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[300])),
      ],
    );
  }
}
