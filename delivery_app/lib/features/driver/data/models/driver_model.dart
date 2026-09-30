import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DriverModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isOnline;
  final bool isAvailable;
  final String currentOrderId;
  final double? latitude;
  final double? longitude;
  final String role;
  final DateTime? createdAt;

  const DriverModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isOnline,
    required this.isAvailable,
    required this.currentOrderId,
    this.latitude,
    this.longitude,
    required this.role,
    this.createdAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'];

    return DriverModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      isOnline: json['isOnline'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      currentOrderId: json['currentOrderId'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      role: json['role'] ?? 'driver',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        isOnline,
        isAvailable,
        currentOrderId,
        latitude,
        longitude,
        role,
        createdAt,
      ]; 
       Map<String,dynamic> toJson () {
 
  return {
 
    'id' : id , 
 
    'name' : name , 
 
    'email' : email , 
 
    'phone' : phone , 
 
    'isOnline' : isOnline, 
 
    'isAvailable' : isAvailable,
 
    'currentOrderId' : currentOrderId, 
 
    'latitude' : latitude, 
 
    'longitude' : longitude, 
    
     'role' : role , 

     'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : null,
 
  }; 
 
 }  
}