import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int ordersCount;
  final DateTime? createdAt;

  const AdminUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.ordersCount,
    this.createdAt,
  });

  factory AdminUserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminUserModel(
      uid: json['uid']?.toString() ?? '',
      name: json['displayname']?.toString() ??
          json['name']?.toString() ??
          '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      ordersCount: _toInt(json['ordersCount']),
      createdAt: _parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayname': name,
      'email': email,
      'phone': phone,
      'role': role,
      'ordersCount': ordersCount,
      'createdAt': createdAt,
    };
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

  static DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}