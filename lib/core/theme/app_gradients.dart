import 'package:cineticket/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppGradients {
  static const LinearGradient authBackdrop = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B1035),
      AppColors.background,
      Color(0xFF0A1628),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static LinearGradient heroBottomFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      AppColors.voidBlack.withOpacity(0.35),
      AppColors.background,
    ],
    stops: const [0.0, 0.42, 1.0],
  );

  static const LinearGradient brandOrb = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accent,
      Color(0xFF7C3AED),
      AppColors.spotlight,
    ],
  );
}
