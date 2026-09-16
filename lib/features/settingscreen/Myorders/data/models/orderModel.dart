import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';

class OrderModel {
  final String id;
  final List<CartItemModel> products;
  final double totalPrice;
  final String address;
  final String status;
  final DateTime date;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.status,
    required this.date,
    required this.paymentMethod,
  });

  OrderModel copyWith({
    String? id,
    List<CartItemModel>? products,
    double? totalPrice,
    String? address,
    String? status,
    DateTime? date,
    String? paymentMethod,
  }) {
    return OrderModel(
      id: id ?? this.id,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      status: status ?? this.status,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalPrice': totalPrice,
      'address': address,
      'status': status,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,

      // Snapshot للمنتجات وقت إنشاء الطلب
      'products': products.map((cartItem) {
        return {
          'cartItemId': cartItem.cartItemId,
          'quantity': cartItem.quantity,
          'selectedColor': cartItem.selectedColor,
          'selectedSize': cartItem.selectedSize,
          'product': cartItem.product.toJson(),
        };
      }).toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List? ?? [];

    final products = productsJson.map((item) {
      final itemMap = Map<String, dynamic>.from(item as Map);

      final productJson = Map<String, dynamic>.from(itemMap['product'] as Map);

      final product = ProductModel.fromJson(productJson);

      return CartItemModel.fromJson(
        product: product,
        json: itemMap,
        cartItemId: itemMap['cartItemId']?.toString() ?? '',
      );
    }).toList();

    return OrderModel(
      id: json['id']?.toString() ?? '',
      products: products,
      totalPrice: _toDouble(json['totalPrice']),
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      paymentMethod: json['paymentMethod']?.toString() ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
