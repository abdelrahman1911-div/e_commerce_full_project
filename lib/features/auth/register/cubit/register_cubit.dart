import 'dart:io';

import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:e_commerce_full_project/features/auth/register/cubit/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> { 
final AuthRepository _authRepository;  

RegisterCubit(this._authRepository) : super(RegisterInitialState()); 

final formKey = GlobalKey<FormState>();
 bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off_outlined; 
  void changePasswordVisibility () {
    isPassword =!isPassword;  
    suffixIcon = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ; 
    emit(RegisterChangePasswordVisibilityState()); 
  } 
  
Future<void> register({
  required String name,
  required String email,
  required String password,
  required String phone,
  File? profileImage,
}) async {
  emit(RegisterLoadingState());

  try {
    final user = await _authRepository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      profileImage: profileImage,
    );

    emit(RegisterSuccessState(user));
  } on FirebaseAuthException catch (e) {
    emit(
      RegisterErrorState(
        e.message ?? 'Registration failed',
      ),
    );
  } catch (e) {
    emit(RegisterErrorState(e.toString()));
  }
}
} 