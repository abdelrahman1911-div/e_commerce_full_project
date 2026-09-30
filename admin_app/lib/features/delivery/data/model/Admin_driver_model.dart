import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDriverModel {
 final String driverId; 
 final String driverName; 
 final String email; 
 final String phone; 
 final bool isOnline ; 
 final bool isAvailable  ; 
 final String currentOrderId; 
 final double? latitude; 
 final double? longitude ; 
 final DateTime? createdAt; 
 final DateTime? assignedAt; 
 
 const AdminDriverModel ({
  required this.driverId, 
  required this.driverName , 
  required this.email, 
  required this.phone,  
   this.isOnline = false , 
   this.isAvailable = false,  
   this.currentOrderId  = '', 
   this.latitude, 
   this.longitude, 
   this.assignedAt, 
   this.createdAt  
 });  

 AdminDriverModel copyWith({
  String ? driverId, 
  String ? driverName, 
  String ? email, 
  String ? phone , 
  bool ? isOnline, 
  bool ? isAvailable, 
  String? currentOrderId, 
  double? latitude, 
  double? longitude, 
  DateTime? assignedAt , 
  DateTime? createdAt  


 }) {
  return AdminDriverModel(
    driverId: driverId ?? this.driverId , 
    driverName: driverName ?? this.driverName ,
    email: email ?? this.email ,
    phone: phone ?? this.phone, 
    isOnline:  isOnline ?? this.isOnline , 
    isAvailable:  isAvailable ?? this.isAvailable, 
    currentOrderId: currentOrderId ?? this.currentOrderId, 
    latitude: latitude ?? this.latitude, 
    longitude: longitude ?? this.longitude, 
    assignedAt: assignedAt ?? this.assignedAt , 
    createdAt: createdAt ?? this.createdAt 
      ); 
 }
  factory AdminDriverModel.fromJson(Map<String, dynamic> json) {
  return AdminDriverModel(
    driverId: json['id']?.toString() ?? '',
    driverName: json['name']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    isOnline: json['isOnline'] as bool? ?? false,
    isAvailable: json['isAvailable'] as bool? ?? false,
    currentOrderId: json['currentOrderId']?.toString() ?? '',
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    createdAt: _parseDate(json['createdAt']),
    assignedAt: _parseDate(json['assignedAt']),
  );
}
Map<String, dynamic> toJson() {
  return {
    'id': driverId,
    'name': driverName,
    'email': email,
    'phone': phone,
    'isOnline': isOnline,
    'isAvailable': isAvailable,
    'currentOrderId': currentOrderId,
    'latitude': latitude,
    'longitude': longitude,
    'createdAt': createdAt,
    'assignedAt': assignedAt,
  };
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

}