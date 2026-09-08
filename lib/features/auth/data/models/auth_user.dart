import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
    final String role;
   final String phone; 
  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl, 
    this.role = "user",  
    this.phone ='',
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl, 
    role, 
    phone, 
  ];
}