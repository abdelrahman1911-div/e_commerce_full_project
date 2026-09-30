class OrderProductModel {
  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;

  const OrderProductModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    final productJson = Map<String, dynamic>.from(
      json['product'] as Map? ?? {},
    );
    return OrderProductModel(
      productId: productJson['id']?.toString() ?? '',
      name: productJson['name']?.toString() ?? '',
      image: productJson['image']?.toString() ?? '',
      price: _toDouble(productJson['currentPrice']),
      quantity: _toInt(json['quantity']),
      selectedColor: json['selectedColor']?.toString(),
      selectedSize: json['selectedSize']?.toString(),
    );
  } 
  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
