import 'package:flutter/material.dart';

/// Paleta inspirada em salas escuras, streaming e destaque tipo “holofote”.
abstract class AppColors {
  static const Color voidBlack = Color(0xFF050508);
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF121826);
  static const Color surfaceElevated = Color(0xFF1A2235);
  static const Color outline = Color(0xFF2D3A4F);

  /// Acento principal — ingresso / play / CTA (tom coral/rosa cinema).
  static const Color accent = Color(0xFFE11D48);
  static const Color accentMuted = Color(0xFFBE123C);

  /// Destaques tipo classificação e seleção.
  static const Color spotlight = Color(0xFFF59E0B);
  static const Color spotlightSoft = Color(0xFFFBBF24);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const Color seatAvailable = Color(0xFF22C55E);
  static const Color seatSelected = Color(0xFFF59E0B);
  static const Color seatOccupied = Color(0xFF475569);
  static const Color seatAccessible = Color(0xFF38BDF8);

  static const Color success = Color(0xFF34D399);
}
