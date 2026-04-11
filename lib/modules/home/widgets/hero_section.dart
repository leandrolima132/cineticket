import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/core/theme/app_gradients.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final bool showSynopsis;

  const HeroSection(
      {super.key, required this.movie, this.onTap, this.showSynopsis = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            movie.posterUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surface,
              child: const Icon(Icons.movie_creation_outlined,
                  size: 80, color: AppColors.textMuted),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.heroBottomFade,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.1,
                  colors: [
                    Colors.transparent,
                    AppColors.voidBlack.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movie.highlight)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'EM DESTAQUE',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 10,
                            letterSpacing: 1.4,
                            color: Colors.white,
                          ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.3,
                    shadows: [
                      Shadow(
                        color: AppColors.voidBlack.withOpacity(0.85),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 20, color: AppColors.spotlightSoft),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating,
                      style: const TextStyle(
                        color: AppColors.spotlightSoft,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.schedule_rounded,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      movie.duration,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: movie.genres.split(', ').map((genre) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.outline.withOpacity(0.45),
                        ),
                      ),
                      child: Text(
                        genre.trim(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                if (showSynopsis)
                  Row(
                    children: [
                      const Icon(Icons.touch_app_rounded,
                          size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        'Toque para ver sinopse e horários',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
