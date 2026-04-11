import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:flutter/material.dart';

class MoviePosterCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MoviePosterCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      margin: const EdgeInsets.only(right: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: AppColors.accent.withOpacity(0.12),
          highlightColor: AppColors.textPrimary.withOpacity(0.06),
          child: Semantics(
            button: true,
            label: 'Ver detalhes de ${movie.title}',
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.voidBlack.withOpacity(0.65),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.outline.withOpacity(0.45),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceElevated,
                            child: Icon(Icons.movie_filter_rounded,
                                size: 48, color: AppColors.textMuted),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          size: 16, color: AppColors.spotlightSoft),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
