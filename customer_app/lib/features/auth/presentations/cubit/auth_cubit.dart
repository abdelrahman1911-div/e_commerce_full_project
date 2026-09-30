import 'package:e_commerce_full_project/features/auth/data/models/auth_user.dart';
import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:e_commerce_full_project/core/errors/firebase_error_messages.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());


  Future<void> login(
    String email,
    String password,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.login(
        email,
        password,
      );

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          FirebaseErrorMessages.getMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AuthError(
          'something_went_wrong',
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();

      emit(AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          FirebaseErrorMessages.getMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AuthError(
          'something_went_wrong',
        ),
      );
    }
  }

  Future<void> checkAuth() async {
    emit(AuthChecking());

    try {
      final user = await _authRepository.checkAuth();

      if (user == null) {
        emit(AuthUnauthenticated());
        return;
      }

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          FirebaseErrorMessages.getMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AuthError(
          'something_went_wrong',
        ),
      );
    }
  }


  Future<void> loginWithGoogle() async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.loginWithGoogle();

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          FirebaseErrorMessages.getMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AuthError(
          'google_login_failed',
        ),
      );
    }
  }


  Future<void> loginWithFacebook() async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.loginWithFacebook();

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          FirebaseErrorMessages.getMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AuthError(
          'facebook_login_failed',
        ),
      );
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(AuthLoading());

    try {
      await _authRepository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      await _authRepository.logout();

      emit(AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          FirebaseErrorMessages.getMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AuthError(
          'change_password_failed',
        ),
      );
    }
  }


  Future<void> sendPasswordResetEmail(
    String email,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.sendPasswordResetEmail(email);

      emit(AuthInitial());
    } on FirebaseAuthException catch (e) {
      emit(
        AuthError(
          FirebaseErrorMessages.getMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AuthError(
          'password_reset_failed',
        ),
      );
    }
  }


  void resetError() {
    emit(AuthInitial());
  }
}