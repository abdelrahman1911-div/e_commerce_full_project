import 'package:equatable/equatable.dart';
class AuthUser extends Equatable {
  final String uid;
  final String? email;
  final String? displayname;
  final String? photoUrl;
   final String phone; 
  const AuthUser({
    required this.uid,
    this.email,
    this.displayname,
    this.photoUrl, 
    this.phone ='',
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    displayname,
    photoUrl, 
    phone, 
  ];
}