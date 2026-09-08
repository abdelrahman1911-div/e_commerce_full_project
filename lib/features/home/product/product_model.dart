import 'package:flutter/material.dart';

class ProductModel {
  final int id;
  final String image;
  final String brand;
  final String rating;
  final String reviews;
  final String name;
  final String currentPrice;
  final String oldPrice;
  final String discount;
  final bool isFavorite;
  final String category;
  final String description;
  final int quantity;
  final List<ProductColor> colors;
  final List<ProductSize> sizes;

  const ProductModel({
    required this.id,
    required this.image,
    required this.brand,
    required this.rating,
    required this.reviews,
    required this.name,
    required this.currentPrice,
    required this.oldPrice,
    required this.discount,
    required this.isFavorite,
    required this.category,
    required this.description,
    this.quantity = 0,
    required this.colors,
    required this.sizes,
  });

  ProductModel copyWith({
    int? id,
    String? image,
    String? brand,
    String? rating,
    String? reviews,
    String? name,
    String? currentPrice,
    String? oldPrice,
    String? discount,
    bool? isFavorite,
    String? category,
    String? description,
    int? quantity,
    List<ProductColor>? colors,
    List<ProductSize>? sizes,
  }) {
    return ProductModel(
      id: id ?? this.id,
      image: image ?? this.image,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      name: name ?? this.name,
      currentPrice: currentPrice ?? this.currentPrice,
      oldPrice: oldPrice ?? this.oldPrice,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      brand: json['brand'] ?? '',
      rating: json['rating']?.toString() ?? '',
      reviews: json['reviews']?.toString() ?? '',
      name: json['name'] ?? '',
      currentPrice: json['currentPrice'] ?? '',
      oldPrice: json['oldPrice'] ?? '',
      discount: json['discount'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      colors:
          (json['colors'] as List?)
              ?.map(
                (color) => ProductColor(
                  name: color['name'],
                  colorValue: Color(color['colorValue']),
                ),
              )
              .toList() ??
          [],

      sizes:
          (json['sizes'] as List?)
              ?.map(
                (size) => ProductSize(
                  label: size['label'],
                  isAvailable: size['isAvailable'],
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'brand': brand,
      'rating': rating,
      'reviews': reviews,
      'name': name,
      'currentPrice': currentPrice,
      'oldPrice': oldPrice,
      'discount': discount,
      'isFavorite': isFavorite,
      'category': category,
      'description': description,
      'quantity': quantity,
      'colors': colors.map((color) => color.toJson()).toList(),
      'sizes': sizes.map((size) => size.toJson()).toList(),
    };
  }
}
class ProductColor {
  final String name;
  final Color colorValue;

  const ProductColor({required this.name, required this.colorValue});
  Map<String, dynamic> toJson() {
    return {'name': name, 'colorValue': colorValue.value};
  }
}
class ProductSize {
  final String label;
  final bool isAvailable;
  const ProductSize({required this.label, required this.isAvailable});
  Map<String, dynamic> toJson() {
    return {'label': label, 'isAvailable': isAvailable};
  }
}
