import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_product_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<OrderProductModel> products;
  final double totalPrice;
  final String address;
  final String status;
  final DateTime? date;
  final String paymentMethod; 
  final String? driverId; 
  final String? driverName; 
  final DateTime? assignedAt; 

  const OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.status,
    required this.date,
    required this.paymentMethod, 
    this.driverId,  
    this.driverName, 
    this.assignedAt  
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderProductModel>? products,
    double? totalPrice,
    String? address,
    String? status,
    DateTime? date,
    String? paymentMethod,
    String? driverId, 
    String? driverName, 
    DateTime? assignedAt,   
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
      driverId: driverId ?? this.driverId, 
      driverName: driverName ?? this.driverName, 
      assignedAt:  assignedAt ?? this.assignedAt,
    );
  }

  factory OrderModel.fromJson(
    Map<String, dynamic> json, {
    required String userId,
  }) {
    final productsJson = json['products'] as List? ?? [];

    final products = productsJson.map((item) {
      return OrderProductModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();

    return OrderModel(
      id: json['id']?.toString() ?? '',
      userId: userId,
      products: products,
      totalPrice: _toDouble(json['totalPrice']),
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      date: _parseDate(json['date']),
      paymentMethod: json['paymentMethod']?.toString() ?? '', 
      driverId: json['driverId']  ?? "", 
      driverName: json['driverName'] ?? "",
      assignedAt: _parseDate(json['assignedAt']),  
    );
  }

  static DateTime? _parseDate(dynamic value) {
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
}