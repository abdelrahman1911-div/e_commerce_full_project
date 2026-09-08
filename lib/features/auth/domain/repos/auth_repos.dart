import 'package:e_commerce_full_project/features/auth/data/models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login(String email, String password);
    Future<AuthUser?> checkAuth();
  Future<void> logout(); 
    void resetError() {} 
    Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
}