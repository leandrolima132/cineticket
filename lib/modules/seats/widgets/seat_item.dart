import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:flutter/material.dart';

class SeatItem extends StatelessWidget {
  final Seat seat;
  final VoidCallback? onTap;

  const SeatItem({super.key, required this.seat, this.onTap});

  Color _fillColor() {
    switch (seat.status) {
      case SeatStatus.available:
        return AppColors.seatAvailable;
      case SeatStatus.selected:
        return AppColors.seatSelected;
      case SeatStatus.occupied:
        return AppColors.seatOccupied;
    }
  }

  Color _borderColor() {
    if (seat.isAccessible) return AppColors.seatAccessible;
    return _fillColor();
  }

  @override
  Widget build(BuildContext context) {
    final isTappable = seat.status != SeatStatus.occupied;
    final fill = _fillColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isTappable ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        splashColor: AppColors.accent.withOpacity(0.2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: seat.isAccessible ? 34 : 30,
          height: seat.isAccessible ? 34 : 30,
          decoration: BoxDecoration(
            color: fill.withOpacity(
              seat.status == SeatStatus.occupied ? 0.35 : 0.28,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _borderColor(),
              width: seat.status == SeatStatus.selected ? 2.2 : 1,
            ),
            boxShadow: seat.status == SeatStatus.selected
                ? [
                    BoxShadow(
                      color: AppColors.seatSelected.withOpacity(0.45),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  seat.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: seat.status == SeatStatus.occupied
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (seat.isAccessible)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Icon(
                    Icons.accessible_rounded,
                    size: 11,
                    color: AppColors.seatAccessible,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
