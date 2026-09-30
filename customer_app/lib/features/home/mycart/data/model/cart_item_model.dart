import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';

class CartItemModel {
  final String cartItemId;
  final ProductModel product;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;

  const CartItemModel({
    required this.cartItemId,
    required this.product,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  CartItemModel copyWith({
    String? cartItemId,
    ProductModel? product,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
  }) {
    return CartItemModel(
      cartItemId: cartItemId ?? this.cartItemId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  factory CartItemModel.fromJson({
    required String cartItemId,
    required ProductModel product,
    required Map<String, dynamic> json,
  }) {
    return CartItemModel(
      cartItemId: cartItemId,
      product: product,
      quantity: _toInt(json['quantity']),
      selectedColor: json['selectedColor']?.toString(),
      selectedSize: json['selectedSize']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
    };
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 1;
  }
}
