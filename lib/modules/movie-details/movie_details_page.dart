import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/core/router/seat_selection_args.dart';
import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/core/widgets/streaming_section_header.dart';
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
                  expandedHeight: 460,
                  pinned: true,
                  stretch: true,
                  backgroundColor: AppColors.background,
                  surfaceTintColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: AppColors.textPrimary),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.zoomBackground,
                    ],
                    background: HeroSection(movie: movie, showSynopsis: false),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ExpandableSynopsis(description: movie.description),
                        const SizedBox(height: 28),
                        const StreamingSectionHeader(
                          overline: 'Ingressos',
                          title: 'Horários de Exibição',
                          subtitle:
                              'Toque em uma sessão para escolher seus assentos',
                        ),
                        const SizedBox(height: 8),
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
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.55,
          ),
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
                style: const TextStyle(
                  color: AppColors.accent,
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

// class _InfoChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;

//   const _InfoChip(
//       {required this.icon, required this.label, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 20, color: color),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: AppColors.textSecondary,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
