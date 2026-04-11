import 'package:cineticket/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StreamingSectionHeader extends StatelessWidget {
  final String overline;
  final String title;
  final String? subtitle;

  const StreamingSectionHeader({
    super.key,
    required this.overline,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            overline.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
