import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_delivery_app/features/auth/data/models/auth_user.dart';
import 'package:e_commerce_delivery_app/features/auth/domain/auth_repos.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(
    this._firebaseAuth,
    this._firestore,
  );

 @override
Future<AuthUser> login(
  String email,
  String password,
) async {
  final credentials =
      await _firebaseAuth.signInWithEmailAndPassword(
    email: email.trim(),
    password: password,
  );

  final User? user = credentials.user;

  if (user == null) {
    throw FirebaseAuthException(
      code: 'user-not-found',
      message: 'User not found.',
    );
  } 

  print('==============================');
  print('AUTH LOGIN SUCCESS');
  print('UID: ${user.uid}');
  print('EMAIL: ${user.email}');
  print('==============================');

  final driverDoc = await _firestore
      .collection('drivers')
      .doc(user.uid)
      .get();

  print('ADMIN DOC EXISTS: ${driverDoc.exists}'); 

  print('ADMIN DOC DATA: ${driverDoc.data()}');

  if (!driverDoc.exists) { 

    await _firebaseAuth.signOut();

    throw FirebaseAuthException(
      code: 'not-driver', 
      message:
          'No driver document found for UID: ${user.uid}',
    );
  }

  final data = driverDoc.data(); 

  final role = data?['role'];

  print('driver ROLE: $role'); 


  if (role != 'driver') { 

    await _firebaseAuth.signOut();

    throw FirebaseAuthException(
      code: 'not-driver', 

      message: 'driver role is invalid: $role',
    );
  }
  
  return AuthUser(
    uid: user.uid, 

    email: email,
  );
}

  @override
  Future<AuthUser?> checkAuth() async { 

    final User? user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    final driverDoc = await _firestore
        .collection('drivers')
        .doc(user.uid)
        .get();

    if (!driverDoc.exists) { 

      await _firebaseAuth.signOut();
      
      return null;
    
    }

    final data = driverDoc.data();

    final role = data?['role'];

    if (role != 'driver') {
    
      await _firebaseAuth.signOut();
    
      return null;
    
    } 
    final email = user.email; 
    if(email == null || email.isEmpty) {
      throw FirebaseAuthException(code: 'missing-Email' , message: 'User email isnot available' ); 
    }
    return AuthUser(
      uid: user.uid,
      email: email, 
    );
  
  }

  
  @override
  
  Future<void> logout() async { 
    await _firebaseAuth.signOut();
  }

  
  @override
  
  Future<void> changePassword({

    required String oldPassword, 

    required String newPassword, 


  }) async {

    final User? user = _firebaseAuth.currentUser;

    if (user == null) {

      throw FirebaseAuthException(

        code: 'user-not-found',

        message: 'No authenticated user found.',

      );

    }

    final email = user.email;

    if (email == null || email.isEmpty) {

      throw FirebaseAuthException(

        code: 'missing-email',

        message: 'User email is not available.',

      );

    }

    final credential = EmailAuthProvider.credential(

      email: email,

      password: oldPassword,
    );

    await user.reauthenticateWithCredential(
      credential,
    );

    await user.updatePassword(newPassword);

  }


  @override

  Future<void> sendPasswordResetEmail(

    String email,

  ) async {

    await _firebaseAuth.sendPasswordResetEmail(
 
      email: email.trim(),
 
    );
 
  }

}