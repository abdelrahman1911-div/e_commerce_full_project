import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;

  final String brandId;
  final String categoryId;

  final String image;
  final List<String> images;

  final double currentPrice;
  final double oldPrice;

  final double rating;
  final int reviewsCount;

  final int stockQuantity;

  final List<ProductColor> colors;
  final List<ProductSize> sizes;

  final DateTime? createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.brandId,
    required this.categoryId,
    required this.image,
    required this.images,
    required this.currentPrice,
    required this.oldPrice,
    required this.rating,
    required this.reviewsCount,
    required this.stockQuantity,
    required this.colors,
    required this.sizes,
    this.createdAt,
  });

  // =========================================================
  // Compatibility getters
  // =========================================================

  /// Used by Cart / Checkout / Orders
  int get quantity => stockQuantity;

  /// Old code uses `reviews`
  String get reviews => reviewsCount.toString();

  /// Old code uses `discount`
  String get discount {
    if (oldPrice <= 0) return '0%';

    final discountValue = ((oldPrice - currentPrice) / oldPrice) * 100;

    return '-${discountValue.round()}%';
  }

  /// Old code may use `brand`
  String get brand => brandId;

  /// Old code may use `category`
  String get category => categoryId;

  // =========================================================
  // copyWith
  // =========================================================

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? brandId,
    String? categoryId,
    String? image,
    List<String>? images,
    double? currentPrice,
    double? oldPrice,
    double? rating,
    int? reviewsCount,
    int? stockQuantity,
    List<ProductColor>? colors,
    List<ProductSize>? sizes,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      brandId: brandId ?? this.brandId,
      categoryId: categoryId ?? this.categoryId,
      image: image ?? this.image,
      images: images ?? this.images,
      currentPrice: currentPrice ?? this.currentPrice,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // =========================================================
  // From JSON
  // =========================================================

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      brandId: json['brandId']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      image: json['image']?.toString() ?? '',

      images:
          (json['images'] as List?)
              ?.map((image) => image.toString())
              .toList() ??
          [],

      currentPrice: _toDouble(json['currentPrice']),
      oldPrice: _toDouble(json['oldPrice']),

      rating: _toDouble(json['rating']),

      reviewsCount: _toInt(json['reviewsCount'] ?? json['reviews']),

      stockQuantity: _toInt(json['stockQuantity'] ?? json['quantity']),

      colors:
          (json['colors'] as List?)
              ?.map(
                (color) =>
                    ProductColor.fromJson(Map<String, dynamic>.from(color)),
              )
              .toList() ??
          [],

      sizes:
          (json['sizes'] as List?)
              ?.map(
                (size) => ProductSize.fromJson(Map<String, dynamic>.from(size)),
              )
              .toList() ??
          [],

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  // =========================================================
  // To JSON
  // =========================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'brandId': brandId,
      'categoryId': categoryId,
      'image': image,
      'images': images,
      'currentPrice': currentPrice,
      'oldPrice': oldPrice,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'stockQuantity': stockQuantity,
      'colors': colors.map((color) => color.toJson()).toList(),
      'sizes': sizes.map((size) => size.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // =========================================================
  // Helpers
  // =========================================================

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

// =============================================================
// Product Color
// =============================================================

class ProductColor {
  final String name;
  final Color colorValue;

  const ProductColor({required this.name, required this.colorValue});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      name: json['name']?.toString() ?? '',
      colorValue: Color(_toColorInt(json['colorValue'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'colorValue': colorValue.value};
  }

  static int _toColorInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

// =============================================================
// Product Size
// =============================================================

class ProductSize {
  final String label;
  final bool isAvailable;

  const ProductSize({required this.label, required this.isAvailable});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      label: json['label']?.toString() ?? '',
      isAvailable: json['isAvailable'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'isAvailable': isAvailable};
  }
}
