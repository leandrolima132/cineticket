import 'package:equatable/equatable.dart';

enum SeatStatus { available, selected, occupied }

class Seat extends Equatable {
  final String id;
  final String row;
  final int number;
  final SeatStatus status;
  final bool isAccessible;

  const Seat({
    required this.id,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
    this.isAccessible = false,
  });

  String get label => '$row$number';

  Seat copyWith({
    String? id,
    String? row,
    int? number,
    SeatStatus? status,
    bool? isAccessible,
  }) {
    return Seat(
      id: id ?? this.id,
      row: row ?? this.row,
      number: number ?? this.number,
      status: status ?? this.status,
      isAccessible: isAccessible ?? this.isAccessible,
    );
  }

  @override
  List<Object?> get props => [id, row, number, status, isAccessible];
}
