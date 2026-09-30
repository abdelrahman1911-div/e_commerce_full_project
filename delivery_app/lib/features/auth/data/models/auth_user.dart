import 'package:equatable/equatable.dart';

class AuthUser extends Equatable { 

  final String uid;
  final String email;
  
  const AuthUser({
  
    required this.uid,
  
    required this.email,
  
  });
  @override
  List<Object?> get props => [
        uid,
        email,
      ];
}