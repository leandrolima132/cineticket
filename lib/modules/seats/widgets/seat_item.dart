import 'package:cineticket/data/models/seat.dart';
import 'package:flutter/material.dart';

class SeatItem extends StatelessWidget {
  final Seat seat;
  final VoidCallback? onTap;

  const SeatItem({super.key, required this.seat, this.onTap});

  Color _getColor() {
    switch (seat.status) {
      case SeatStatus.available:
        return Colors.green;
      case SeatStatus.selected:
        return Colors.orange;
      case SeatStatus.occupied:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTappable = seat.status != SeatStatus.occupied;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isTappable ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: seat.isAccessible ? 34 : 30,
          height: seat.isAccessible ? 34 : 30,
          decoration: BoxDecoration(
            color: _getColor().withOpacity(
              seat.status == SeatStatus.occupied ? 0.4 : 0.3,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: seat.isAccessible ? Colors.blue.shade300 : _getColor(),
              width: seat.status == SeatStatus.selected ? 2 : 1,
            ),
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
                        ? Colors.grey[600]
                        : Colors.white,
                  ),
                ),
              ),
              if (seat.isAccessible)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Icon(
                    Icons.accessible,
                    size: 10,
                    color: Colors.blue.shade300,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
