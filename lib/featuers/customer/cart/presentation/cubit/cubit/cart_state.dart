part of 'cart_cubit.dart';

abstract class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);
}

final class CartError extends CartState {
  final String error;

  CartError(this.error);
}

final class AddToCartLoading extends CartState {}

final class AddToCartSuccess extends CartState {}

final class AddToCartError extends CartState {
  final String error;

  AddToCartError(this.error);
}

final class RemoveFromCartLoading extends CartState {}
final class RemoveFromCartSuccess extends CartState {}
final class RemoveFromCartError extends CartState {
  final String error;

  RemoveFromCartError(this.error);
}

final class CartEmpty extends CartState {}

final class OrderCreate extends CartState {}

final class OrderCreateError extends CartState {
  final String error;

  OrderCreateError(this.error);
}

final class OrderCreated extends CartState {}