import 'dart:io';

import 'package:e_commerce_full_project/features/home/profile/data/models/user_model.dart';
import 'package:e_commerce_full_project/features/home/profile/domain/repositories/user_repository.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/cubit/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
 final UserRepository _userRepository ; 
 UserCubit(this._userRepository) : super(UserInitial()); 
 
 Future<void> getUser(String uid) async {
  emit(UserLoading()); 
  try{
   final user = await _userRepository.getUser(uid);   
   emit(UserLoaded(user)); 
 }
 catch(e){
  emit(UserError(e.toString()));  
 } 
 } 
 
  Future<void> updateUser (UserModel user) async { 
    emit(UserUpdating(user)); 
    try{
       await _userRepository.updateUser(user); 
       emit(UserUpdated(user)); 
    } catch(e) {
      emit(UserError(e.toString())); 
    }
  }  
  Future <void> updateProfileImage({
    required String uid, 
    required File imageFile
  }) async  {
    try {
        emit(UserLoading());

    final imageUrl = await _userRepository.uploadProfileImage(
      uid: uid,
      imageFile: imageFile,
    );

    emit(UserProfileImageUpdated(imageUrl));
    } catch (e) {
          emit(UserError(e.toString()));
    }

  }

} 