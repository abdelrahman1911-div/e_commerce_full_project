import 'package:e_commerce_delivery_app/features/auth/data/models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login(
    String email,
    String password,
  );

  Future<AuthUser?> checkAuth();

  Future<void> logout();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<void> sendPasswordResetEmail(
    String email,
  );
}
