import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:e_commerce_full_project/features/auth/register/cubit/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> { 
final AuthRepository _authRepository;  

RegisterCubit(this._authRepository) : super(RegisterInitialState()); 

final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
 bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off_outlined; 
  void changePasswordVisibility () {
    isPassword =!isPassword;  
    suffixIcon = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ; 
    emit(RegisterChangePasswordVisibilityState()); 
  } 
  
 Future <void> register () async  {
   

 emit(RegisterLoadingState()); 

 try {
   final user = await _authRepository.register(
    name: nameController.text.trim(),
     email: emailController.text.trim(),
      password: passwordController.text.trim(),
       phone:  
       phoneController.text.trim(), ); 
   emit(RegisterSuccessState(user)); 
 
 } on FirebaseAuthException catch(e) {
   emit(RegisterErrorState((e.toString())));
 
 }
  catch(e){
       emit(RegisterErrorState((e.toString())));
 }
 } 
  
   @override
  Future<void> close() { 

    nameController.dispose(); 

    emailController.dispose(); 

    phoneController.dispose(); 

    passwordController.dispose(); 

    return super.close(); 

  } 
} 