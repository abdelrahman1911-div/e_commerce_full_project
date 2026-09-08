import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<List<ProductModel>> {
  CartCubit() : super([]);


  void addToCart(ProductModel product) {
    final updatedCart = [...state];

    final index = updatedCart.indexWhere(
      (item) => item.id == product.id,
    );

    if (index != -1) {
      final currentProduct = updatedCart[index];

      updatedCart[index] = currentProduct.copyWith(
        quantity: currentProduct.quantity +1 ,
      );
    } else {
      updatedCart.add(
        product.copyWith(
          quantity: 1,
        ),
      );
    }

    emit(updatedCart);
  }


  void increaseQuantity(ProductModel product) {
    final updatedCart = [...state];

    final index = updatedCart.indexWhere(
      (item) => item.id == product.id,
    );

    if (index != -1) {
      final currentProduct = updatedCart[index];

      updatedCart[index] = currentProduct.copyWith(
        quantity: currentProduct.quantity + 1,
      );
    }

    emit(updatedCart);
  }


  void decreaseQuantity(ProductModel product) {
    final updatedCart = [...state];

    final index = updatedCart.indexWhere(
      (item) => item.id == product.id,
    );

    if (index != -1) {
      final currentProduct = updatedCart[index];

      if (currentProduct.quantity > 1) {
        updatedCart[index] = currentProduct.copyWith(
          quantity: currentProduct.quantity - 1,
        );
      } else {
        updatedCart.removeAt(index);
      }
    }

    emit(updatedCart);
  }

  // =========================
  // REMOVE FROM CART
  // =========================

  void removeFromCart(ProductModel product) {
    final updatedCart = [...state];

    updatedCart.removeWhere(
      (item) => item.id == product.id,
    );

    emit(updatedCart);
  }

  // =========================
  // CLEAR CART
  // =========================

  void clearCart() {
    emit([]);
  }
}