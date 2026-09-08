import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> { 
 final AuthRepository _authRepository; 
 
 AuthCubit(this._authRepository) :super(AuthInitial()); 

 Future<void> login(String email , String password) async {
   emit(AuthLoading());   
   
    try{
     final user = await _authRepository.login(email, password); 
     emit(AuthSuccess(user)); 
    }catch(e){
      emit(AuthError(e.toString())); 
    }  
 }  
  Future<void> logout() async {
    await _authRepository.logout(); 
    emit(AuthInitial()); 
  }  
  Future<void> checkAuth() async {
  emit(AuthChecking());

  try {
    final user = await _authRepository.checkAuth();

    if (user == null) {
      emit(AuthInitial());
      return;
    }

    emit(AuthSuccess(user));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
} 
 void resetError() { 
  emit(AuthInitial()); 
 }
}