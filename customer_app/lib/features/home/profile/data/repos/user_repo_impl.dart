import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/home/profile/data/models/user_model.dart';
import 'package:e_commerce_full_project/features/home/profile/domain/repositories/user_repository.dart';

class UserRepoImpl implements UserRepository {
  final FirebaseFirestore _firebaseFirestore;  
  final _cloudinaryservice; 
  UserRepoImpl(this._firebaseFirestore , this._cloudinaryservice);  

  @override 
  Future<UserModel> getUser(String uid) async  { 
    final doc = await _firebaseFirestore.collection('users').doc(uid).get(); 
    if(!doc.exists){
      throw Exception("User data not found"); 
    }    
    return UserModel.fromMap(doc.data()!); 
  } 
  @override  
  Future<void> updateUser (UserModel user) async {
    await _firebaseFirestore.collection('users').doc(user.uid).update(user.toMap()); 
  } 
  Future<String> uploadProfileImage({
  required String uid,
  required File imageFile,
}) async {
  final imageUrl = await _cloudinaryservice.uploadProfileImage(imageFile);
  await _firebaseFirestore.collection('users').doc(uid).update({
    'photoUrl': imageUrl,
  });
  return imageUrl;
}
}