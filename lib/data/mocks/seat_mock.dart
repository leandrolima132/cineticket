import 'dart:math';

import 'package:cineticket/data/models/seat.dart';

/// Mock de sala com 140 assentos: 14 fileiras (A–N) × 10 assentos por fileira.
/// Parte dos assentos vem ocupada aleatoriamente. Alguns são preferenciais (deficientes).
class SeatMock {
  static const int _rowsCount = 14;
  static const int _seatsPerRow = 10;
  static const int _totalSeats = _rowsCount * _seatsPerRow;

  /// Quantidade de assentos ocupados sorteados por sessão.
  static const int _occupiedCount = 50;

  /// Apenas na fileira A, assentos 1 a 8: 1 preferencial, 2 comuns (A1, A4, A7 são preferenciais).
  static bool _isAccessible(int rowIndex, int seatNumber) {
    if (rowIndex != 0) return false; // só fileira A
    if (seatNumber > 8) return false;
    return (seatNumber - 1) % 3 == 0; // 1, 4, 7
  }

  static final List<String> _rowLetters = List.generate(
    _rowsCount,
    (i) => String.fromCharCode('A'.codeUnitAt(0) + i),
  );

  /// Gera índices aleatórios de assentos ocupados (fixo por sessão, via cache).
  static Set<int> _randomOccupiedIndices([Random? random]) {
    final rnd = random ?? Random();
    final indices = <int>{};
    while (indices.length < _occupiedCount) {
      indices.add(rnd.nextInt(_totalSeats));
    }
    return indices;
  }

  static List<Seat> get seatsList => _buildSeats(_randomOccupiedIndices());

  static List<Seat> _buildSeats(Set<int> occupiedIndices) {
    final list = <Seat>[];
    for (var rowIndex = 0; rowIndex < _rowsCount; rowIndex++) {
      final row = _rowLetters[rowIndex];
      for (var num = 1; num <= _seatsPerRow; num++) {
        final index = rowIndex * _seatsPerRow + (num - 1);
        list.add(Seat(
          id: '${row.toLowerCase()}$num',
          row: row,
          number: num,
          status: occupiedIndices.contains(index)
              ? SeatStatus.occupied
              : SeatStatus.available,
          isAccessible: _isAccessible(rowIndex, num),
        ));
      }
    }
    return list;
  }
}
