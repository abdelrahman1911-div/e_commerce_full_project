import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> getCart();

  Future<void> addToCart(
    String productId,
    String? selectedColor,
    String? selectedSize,
  );

  Future<void> increaseQuantity(String cartItemId);

  Future<void> decreaseQuantity(String cartItemId);

  Future<void> removeFromCart(String cartItemId);

  Future<void> clearCart();
}
