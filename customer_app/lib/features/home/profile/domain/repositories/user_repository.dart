import 'dart:io';

import 'package:e_commerce_full_project/features/home/profile/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser(String uid);  
  Future <void> updateUser(UserModel user);  
  Future<String> uploadProfileImage({
  required String uid,
  required File imageFile,
});
}