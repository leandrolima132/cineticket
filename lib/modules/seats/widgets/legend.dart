import 'package:cineticket/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.85),
        border: Border(
          top: BorderSide(color: AppColors.outline.withOpacity(0.35)),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(color: AppColors.seatAvailable, label: 'Disponível'),
          SizedBox(width: 20),
          _LegendItem(color: AppColors.seatSelected, label: 'Selecionado'),
          SizedBox(width: 20),
          _LegendItem(color: AppColors.seatOccupied, label: 'Ocupado'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color.withOpacity(0.28),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: color, width: 1.2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
