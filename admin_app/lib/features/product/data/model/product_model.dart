import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminProductModel {
  final String id;
  final String name;
  final String description;

  final String brandId;
  final String categoryId;

  final String brandName;
  final String categoryName;

  final String image;
  final List<String> images;

  final double currentPrice;
  final double oldPrice;

  final double rating;
  final int reviewsCount;
  final int stockQuantity;

  final List<AdminProductColor> colors;
  final List<AdminProductSize> sizes;

  final DateTime? createdAt;

  const AdminProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.brandId,
    required this.categoryId,
    this.brandName = '',
    this.categoryName = '',
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

  String get discount {
    if (oldPrice <= 0) {
      return '0%';
    }

    final value =
        ((oldPrice - currentPrice) / oldPrice) * 100;

    return '${value.round()}%';
  }

  factory AdminProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description:
          json['description']?.toString() ?? '',
      brandId:
          json['brandId']?.toString() ?? '',
      categoryId:
          json['categoryId']?.toString() ?? '',
      brandName:
          json['brandName']?.toString() ?? '',
      categoryName:
          json['categoryName']?.toString() ?? '',
      image:
          json['image']?.toString() ?? '',
      images: _toStringList(
        json['images'],
      ),
      currentPrice:
          _toDouble(json['currentPrice']),
      oldPrice:
          _toDouble(json['oldPrice']),
      rating:
          _toDouble(json['rating']),
      reviewsCount:
          _toInt(
            json['reviewsCount'] ??
                json['reviews'],
          ),
      stockQuantity:
          _toInt(
            json['stockQuantity'] ??
                json['quantity'],
          ),
      colors:
          _toColors(json['colors']),
      sizes:
          _toSizes(json['sizes']),
      createdAt:
          _parseDate(json['createdAt']),
    );
  }

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
      'colors': colors
          .map(
            (color) => color.toJson(),
          )
          .toList(),
      'sizes': sizes
          .map(
            (size) => size.toJson(),
          )
          .toList(),
    };
  }

  static List<String> _toStringList(
    dynamic value,
  ) {
    if (value is List) {
      return value
          .map(
            (item) => item.toString(),
          )
          .toList();
    }

    return [];
  }

  static List<AdminProductColor> _toColors(
    dynamic value,
  ) {
    if (value is! List) {
      return [];
    }

    return value
        .map(
          (item) {
            return AdminProductColor.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            );
          },
        )
        .toList();
  }

  static List<AdminProductSize> _toSizes(
    dynamic value,
  ) {
    if (value is! List) {
      return [];
    }

    return value
        .map(
          (item) {
            return AdminProductSize.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            );
          },
        )
        .toList();
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static DateTime? _parseDate(
    dynamic value,
  ) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}

class AdminProductColor {
  final String name;
  final Color colorValue;

  const AdminProductColor({
    required this.name,
    required this.colorValue,
  });

  factory AdminProductColor.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminProductColor(
      name: json['name']?.toString() ?? '',
      colorValue: Color(
        _toColorInt(
          json['colorValue'],
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'colorValue': colorValue.value,
    };
  }

  static int _toColorInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0xFF000000;
  }
}

class AdminProductSize {
  final String label;
  final bool isAvailable;

  const AdminProductSize({
    required this.label,
    required this.isAvailable,
  });

  factory AdminProductSize.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminProductSize(
      label: json['label']?.toString() ?? '',
      isAvailable:
          json['isAvailable'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'isAvailable': isAvailable,
    };
  }
}