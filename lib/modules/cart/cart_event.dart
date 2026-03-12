import 'package:cineticket/data/models/cart_item.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final CartItem item;

  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFromCartEvent extends CartEvent {
  final int index;

  const RemoveFromCartEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
