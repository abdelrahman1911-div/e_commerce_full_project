import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String uid;
  final String displayname;
  final String email;
  final String phoneNumber;
  final String address;
  final String? photoUrl;
  final DateTime? createdAt;
  const UserModel({
    required this.uid,
    required this.displayname,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.photoUrl,
    this.createdAt,
  });
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      displayname: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone'] ?? '',
      address: map['address'] ?? '',
      photoUrl: map['photoUrl'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': displayname,
      'email': email,
      'phone': phoneNumber,
      'address': address,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }
  UserModel copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? address,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid,
      displayname: displayName ?? this.displayname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
