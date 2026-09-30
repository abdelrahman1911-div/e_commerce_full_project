import 'dart:io';

import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:e_commerce_full_project/features/auth/register/cubit/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository)
      : super(RegisterInitialState());

  final formKey = GlobalKey<FormState>();

  bool isPassword = true;

  IconData suffixIcon =
      Icons.visibility_off_outlined;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffixIcon = isPassword
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;

    emit(
      RegisterChangePasswordVisibilityState(),
    );
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

      emit(
        RegisterSuccessState(user),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Register Error Code: ${e.code}',
      );

      debugPrint(
        'Firebase Register Error Message: ${e.message}',
      );

      emit(
        RegisterErrorState(
          _getFirebaseErrorKey(e.code),
        ),
      );
    } catch (e) {
      debugPrint(
        'Register Error: $e',
      );

      emit(
        RegisterErrorState(
          'registration_failed',
        ),
      );
    }
  }

  String _getFirebaseErrorKey(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'email_already_in_use';

      case 'invalid-email':
        return 'invalid_email';

      case 'weak-password':
        return 'weak_password';

      case 'operation-not-allowed':
        return 'registration_not_allowed';

      case 'network-request-failed':
        return 'network_error';

      case 'too-many-requests':
        return 'too_many_requests';

      default:
        return 'registration_failed';
    }
  }
}
