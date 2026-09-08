import 'package:e_commerce_full_project/features/auth/data/models/auth_user.dart';
import 'package:equatable/equatable.dart';

class RegisterState extends Equatable  {
  const RegisterState(); 
  
  @override 
  
  List<Object?> get props => []; 
} 
class RegisterInitialState extends RegisterState {} 
class RegisterLoadingState extends RegisterState {}  
class RegisterSuccessState extends RegisterState {
  final AuthUser user;  
  const RegisterSuccessState(this.user); 
  List <Object?> get props => [user]; 
}  
class RegisterErrorState extends RegisterState {
  final String message ; 
  const RegisterErrorState(this.message); 
  List<Object?> get props => [message]; 
} 
class RegisterChangePasswordVisibilityState extends RegisterState {}

