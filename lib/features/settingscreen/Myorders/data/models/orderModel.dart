import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> products;
  final double totalPrice;
  final String address;
  final String status;
  final DateTime date;
  final String paymentMethod;

  final String recipientName;
  final String recipientPhone;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? deliveryNotes;

  final String? driverId;
  final String? driverName;

  final DateTime? assignedAt;
  final DateTime? pickedUpAt;
  final DateTime? onTheWayAt;
  final DateTime? deliveredAt;

  final String paymentStatus;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.status,
    required this.date,
    required this.paymentMethod,
    required this.recipientName,
    required this.recipientPhone,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryNotes,
    this.driverId,
    this.driverName,
    this.assignedAt,
    this.pickedUpAt,
    this.onTheWayAt,
    this.deliveredAt,
    required this.paymentStatus,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? products,
    double? totalPrice,
    String? address,
    String? status,
    DateTime? date,
    String? paymentMethod,
    String? recipientName,
    String? recipientPhone,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? deliveryNotes,
    String? driverId,
    String? driverName,
    DateTime? assignedAt,
    DateTime? pickedUpAt,
    DateTime? onTheWayAt,
    DateTime? deliveredAt,
    String? paymentStatus,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      status: status ?? this.status,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      assignedAt: assignedAt ?? this.assignedAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      onTheWayAt: onTheWayAt ?? this.onTheWayAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
    'id': id,
    'userId': userId,
    'totalPrice': totalPrice,
    'address': address,
    'status': status,
    'date': Timestamp.fromDate(date),
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'recipientName': recipientName,
    'recipientPhone': recipientPhone,
    'deliveryLatitude': deliveryLatitude,
    'deliveryLongitude': deliveryLongitude,
    'deliveryNotes': deliveryNotes,
    'driverId': driverId,
    'driverName': driverName,
    'assignedAt': assignedAt == null
        ? null
        : Timestamp.fromDate(assignedAt!),
    'pickedUpAt': pickedUpAt == null
        ? null
        : Timestamp.fromDate(pickedUpAt!),
    'onTheWayAt': onTheWayAt == null
        ? null
        : Timestamp.fromDate(onTheWayAt!),
    'deliveredAt': deliveredAt == null
        ? null
        : Timestamp.fromDate(deliveredAt!),
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
      final productJson = Map<String, dynamic>.from(
        itemMap['product'] as Map? ?? {},
      );
      final product = ProductModel.fromJson(productJson);
      return CartItemModel.fromJson(
        product: product,
        json: itemMap,
        cartItemId: itemMap['cartItemId']?.toString() ?? '',
      );
    }).toList();
    return OrderModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      products: products,
      totalPrice: _toDouble(json['totalPrice']),
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? 'placed',
      date: _parseDate(json['date']),
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? 'unpaid',

      recipientName: json['recipientName']?.toString() ?? '',
      recipientPhone: json['recipientPhone']?.toString() ?? '',
      deliveryLatitude: _toNullableDouble(json['deliveryLatitude']),
      deliveryLongitude: _toNullableDouble(json['deliveryLongitude']),
      deliveryNotes: json['deliveryNotes']?.toString(),

      driverId: json['driverId']?.toString(),
      driverName: json['driverName']?.toString(),
      assignedAt: _parseNullableDate(json['assignedAt']),
      pickedUpAt: _parseNullableDate(json['pickedUpAt']),
      onTheWayAt: _parseNullableDate(json['onTheWayAt']),
      deliveredAt: _parseNullableDate(json['deliveredAt']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }

  static DateTime? _parseNullableDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static double? _toNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}