import 'package:bloc_test/bloc_test.dart';
import 'package:cineticket/data/models/cart_item.dart';
import 'package:cineticket/data/models/movie.dart';
import 'package:cineticket/data/models/seat.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_event.dart';
import 'package:cineticket/modules/cart/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const movie = Movie(
    id: 'cart-m1',
    title: 'Filme Cart',
    description: 'd',
    posterUrl: 'https://example.com/p.jpg',
    duration: '90 min',
    genres: 'T',
    rating: '7',
    releaseDate: '2024-01-01',
  );

  final showtime = Showtime(
    id: 'cart-st1',
    movieId: 'cart-m1',
    theater: 'Cinema X',
    room: 'Sala 2',
    dateTime: DateTime(2024, 6, 1, 15, 0),
    availableSeats: 30,
  );

  const seat1 = Seat(id: 'ca1', row: 'C', number: 1);
  const seat2 = Seat(id: 'ca2', row: 'C', number: 2);

  final itemOneSeat = CartItem(
    movie: movie,
    showtime: showtime,
    seats: const [seat1],
  );

  final itemTwoSeats = CartItem(
    movie: movie,
    showtime: showtime,
    seats: const [seat1, seat2],
  );

  group('CartBloc', () {
    test('estado inicial', () {
      final bloc = CartBloc();
      expect(bloc.state, const CartState());
      expect(bloc.state.totalItems, 0);
      addTearDown(bloc.close);
    });

    blocTest<CartBloc, CartState>(
      'AddToCartEvent adiciona item',
      build: CartBloc.new,
      act: (bloc) => bloc.add(AddToCartEvent(itemOneSeat)),
      expect: () => [
        CartState(items: [itemOneSeat]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'vários AddToCartEvent acumulam itens',
      build: CartBloc.new,
      act: (bloc) {
        bloc.add(AddToCartEvent(itemOneSeat));
        bloc.add(AddToCartEvent(itemTwoSeats));
      },
      expect: () => [
        CartState(items: [itemOneSeat]),
        CartState(items: [itemOneSeat, itemTwoSeats]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'RemoveFromCartEvent remove pelo índice',
      build: CartBloc.new,
      act: (bloc) {
        bloc.add(AddToCartEvent(itemOneSeat));
        bloc.add(AddToCartEvent(itemTwoSeats));
        bloc.add(const RemoveFromCartEvent(0));
      },
      expect: () => [
        CartState(items: [itemOneSeat]),
        CartState(items: [itemOneSeat, itemTwoSeats]),
        CartState(items: [itemTwoSeats]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'RemoveFromCartEvent com índice inválido não emite',
      build: CartBloc.new,
      act: (bloc) {
        bloc.add(AddToCartEvent(itemOneSeat));
        bloc.add(const RemoveFromCartEvent(99));
      },
      expect: () => [
        CartState(items: [itemOneSeat]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'ClearCartEvent esvazia o carrinho',
      build: CartBloc.new,
      act: (bloc) {
        bloc.add(AddToCartEvent(itemOneSeat));
        bloc.add(const ClearCartEvent());
      },
      expect: () => [
        CartState(items: [itemOneSeat]),
        const CartState(),
      ],
    );
  });
}
