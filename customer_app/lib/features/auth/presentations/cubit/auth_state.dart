import 'package:e_commerce_full_project/features/auth/data/models/auth_user.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
 const AuthState(); 
 @override
  List <Object?> get props =>[]; 
} 
class AuthInitial extends AuthState {

} 
class AuthChecking extends AuthState {}

class AuthLoading extends AuthState{}  
class AuthUnauthenticated extends AuthState {}
class AuthSuccess extends AuthState{
  final AuthUser user ;
  const AuthSuccess(this.user); 
  @override 
  List<Object?> get props => [user]; 
}  
class AuthError extends AuthState {
  final String message ; 
  const AuthError (this.message); 
  @override
  List<Object?> get props => [message];  
}
