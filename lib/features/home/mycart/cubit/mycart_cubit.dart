import 'dart:developer';
import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';
import 'package:e_commerce_full_project/features/home/mycart/domain/cart_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================
// STATES
// ============================================================

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;

  const CartLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================================
// CUBIT
// ============================================================

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;

  CartCubit(this._cartRepository) : super(CartInitial());

  List<CartItemModel> cartItems = [];

  // ============================================================
  // GET CART
  // ============================================================

  Future<void> getCart() async {
    emit(CartLoading());

    try {
      final items = await _cartRepository.getCart();

      cartItems = items;

      emit(
        CartLoaded(
          List<CartItemModel>.from(cartItems),
        ),
      );

      log(
        'Cart loaded successfully: ${cartItems.length} items',
      );
    } catch (e) {
      log('Failed to load cart: $e');

      emit(
        CartError(e.toString()),
      );
    }
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> addToCart({
    required String productId,
    String? selectedColor,
    String? selectedSize,
  }) async {
    try {
      await _cartRepository.addToCart(
        productId,
        selectedColor,
        selectedSize,
      );

      await getCart();

      log(
        'Product added to cart successfully: '
        '$productId | '
        'color: $selectedColor | '
        'size: $selectedSize',
      );
    } catch (e) {
      log('Failed to add product to cart: $e');

      emit(
        CartError(e.toString()),
      );
    }
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  Future<void> increaseQuantity(String cartItemId) async {
    try {
      await _cartRepository.increaseQuantity(cartItemId);

      await getCart();

      log(
        'Cart quantity increased: $cartItemId',
      );
    } catch (e) {
      log(
        'Failed to increase cart quantity: $e',
      );

      emit(
        CartError(e.toString()),
      );
    }
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  Future<void> decreaseQuantity(String cartItemId) async {
    try {
      await _cartRepository.decreaseQuantity(cartItemId);

      await getCart();

      log(
        'Cart quantity decreased: $cartItemId',
      );
    } catch (e) {
      log(
        'Failed to decrease cart quantity: $e',
      );

      emit(
        CartError(e.toString()),
      );
    }
  }

  // ============================================================
  // REMOVE
  // ============================================================

  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _cartRepository.removeFromCart(cartItemId);

      await getCart();

      log(
        'Product removed from cart successfully: $cartItemId',
      );
    } catch (e) {
      log(
        'Failed to remove product from cart: $e',
      );

      emit(
        CartError(e.toString()),
      );
    }
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  Future<void> clearCart() async {
    try {
      await _cartRepository.clearCart();

      cartItems = [];

      emit(
        const CartLoaded([]),
      );

      log('Cart cleared successfully');
    } catch (e) {
      log(
        'Failed to clear cart: $e',
      );

      emit(
        CartError(e.toString()),
      );
    }
  }
}
