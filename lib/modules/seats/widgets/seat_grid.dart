import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/modules/seats/widgets/seat_item.dart';
import 'package:flutter/material.dart';

const double _kInitialScale = 0.8;

class SeatGrid extends StatefulWidget {
  final List<Seat> seats;
  final void Function(Seat seat) onSeatTap;

  const SeatGrid({
    super.key,
    required this.seats,
    required this.onSeatTap,
  });

  @override
  State<SeatGrid> createState() => _SeatGridState();
}

class _SeatGridState extends State<SeatGrid> {
  late final TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transformationController.value = Matrix4.identity()
        ..scale(_kInitialScale);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Map<String, List<Seat>> _groupByRow() {
    final grouped = <String, List<Seat>>{};
    for (final seat in widget.seats) {
      grouped.putIfAbsent(seat.row, () => []).add(seat);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.number.compareTo(b.number));
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return Map.fromEntries(sortedKeys.map((k) => MapEntry(k, grouped[k]!)));
  }

  @override
  Widget build(BuildContext context) {
    final rows = _groupByRow();

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.1,
      maxScale: 2.5,
      constrained: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1.1,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 48),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'TELA',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ...rows.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < entry.value.length; i++) ...[
                          if (i == 2) const SizedBox(width: 16),
                          if (i == 8) const SizedBox(width: 16),
                          SeatItem(
                            seat: entry.value[i],
                            onTap: () => widget.onSeatTap(entry.value[i]),
                          ),
                          if (i < entry.value.length - 1)
                            const SizedBox(width: 6),
                        ],
                      ],
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 24,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'FUNDO',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
