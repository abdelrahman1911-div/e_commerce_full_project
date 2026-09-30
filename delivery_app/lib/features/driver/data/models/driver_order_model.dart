import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DriverOrderModel extends Equatable {
  final String id;
  final String userId;
  final String recipientName;
  final String recipientPhone;
  final String address;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String deliveryNotes;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? driverId;
  final String? driverName;
  final DateTime? assignedAt;

  const DriverOrderModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.recipientPhone,
    required this.address,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryNotes,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.driverId,
    this.driverName,
    this.assignedAt,
  });

  factory DriverOrderModel.fromJson(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    final assignedAtTimestamp = data['assignedAt'] as Timestamp?;

    return DriverOrderModel(
      id: data['id'] ?? doc.id,
      userId: data['userId'] ?? '',
      recipientName: data['recipientName'] ?? '',
      recipientPhone: data['recipientPhone'] ?? '',
      address: data['address'] ?? '',
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0,
      status: data['status'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      paymentStatus: data['paymentStatus'] ?? '',
      deliveryNotes: data['deliveryNotes'] ?? '',
      deliveryLatitude:
          (data['deliveryLatitude'] as num?)?.toDouble(),
      deliveryLongitude:
          (data['deliveryLongitude'] as num?)?.toDouble(),
      driverId: data['driverId'],
      driverName: data['driverName'],
      assignedAt: assignedAtTimestamp?.toDate(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        recipientName,
        recipientPhone,
        address,
        totalPrice,
        status,
        paymentMethod,
        paymentStatus,
        deliveryNotes,
        deliveryLatitude,
        deliveryLongitude,
        driverId,
        driverName,
        assignedAt,
      ];
}