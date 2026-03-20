import 'package:bloc_test/bloc_test.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/modules/seats/seats_bloc.dart';
import 'package:cineticket/modules/seats/seats_event.dart';
import 'package:cineticket/modules/seats/seats_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_seat_repository.dart';

void main() {
  const showtimeId = 'st-seats';

  const seatA1 = Seat(
    id: 'a1',
    row: 'A',
    number: 1,
    status: SeatStatus.available,
  );

  const seatA2Occupied = Seat(
    id: 'a2',
    row: 'A',
    number: 2,
    status: SeatStatus.occupied,
  );

  group('SeatsBloc', () {
    test('estado inicial', () {
      final bloc = SeatsBloc(
        seatRepository: FakeSeatRepository(seats: const [seatA1]),
      );
      expect(bloc.state, const SeatsState());
      addTearDown(bloc.close);
    });

    blocTest<SeatsBloc, SeatsState>(
      'LoadSeatsEvent: emite carregando e sucesso com assentos',
      build: () => SeatsBloc(
        seatRepository:
            FakeSeatRepository(seats: const [seatA1, seatA2Occupied]),
      ),
      act: (bloc) => bloc.add(const LoadSeatsEvent(showtimeId)),
      expect: () => [
        const SeatsState(
          seats: [],
          isLoading: true,
          errorMessage: null,
        ),
        const SeatsState(
          seats: [seatA1, seatA2Occupied],
          isLoading: false,
          errorMessage: null,
        ),
      ],
    );

    blocTest<SeatsBloc, SeatsState>(
      'LoadSeatsEvent: emite erro quando getSeats falha',
      build: () => SeatsBloc(
        seatRepository: FakeSeatRepository(
          seats: const [],
          error: Exception('rede'),
        ),
      ),
      act: (bloc) => bloc.add(const LoadSeatsEvent(showtimeId)),
      expect: () => [
        const SeatsState(
          seats: [],
          isLoading: true,
          errorMessage: null,
        ),
        const SeatsState(
          seats: [],
          isLoading: false,
          errorMessage: 'Exception: rede',
        ),
      ],
    );

    blocTest<SeatsBloc, SeatsState>(
      'ToggleSeatEvent: alterna disponível para selecionado e volta',
      build: () => SeatsBloc(
        seatRepository: FakeSeatRepository(seats: const [seatA1]),
      ),
      act: (bloc) async {
        bloc.add(const LoadSeatsEvent(showtimeId));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ToggleSeatEvent(seatA1));
        bloc.add(
          ToggleSeatEvent(
            seatA1.copyWith(status: SeatStatus.selected),
          ),
        );
      },
      expect: () => [
        const SeatsState(seats: [], isLoading: true, errorMessage: null),
        const SeatsState(
          seats: [seatA1],
          isLoading: false,
          errorMessage: null,
        ),
        SeatsState(
          seats: [seatA1.copyWith(status: SeatStatus.selected)],
          isLoading: false,
          errorMessage: null,
        ),
        const SeatsState(
          seats: [seatA1],
          isLoading: false,
          errorMessage: null,
        ),
      ],
    );

    blocTest<SeatsBloc, SeatsState>(
      'ToggleSeatEvent: não altera assento ocupado',
      build: () => SeatsBloc(
        seatRepository: FakeSeatRepository(seats: const [seatA2Occupied]),
      ),
      act: (bloc) async {
        bloc.add(const LoadSeatsEvent(showtimeId));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ToggleSeatEvent(seatA2Occupied));
      },
      expect: () => [
        const SeatsState(seats: [], isLoading: true, errorMessage: null),
        const SeatsState(
          seats: [seatA2Occupied],
          isLoading: false,
          errorMessage: null,
        ),
      ],
    );
  });
}
