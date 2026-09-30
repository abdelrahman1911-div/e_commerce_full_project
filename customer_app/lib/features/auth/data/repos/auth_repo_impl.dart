import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/core/helpers/cloudinaryservice/cloudinary_service.dart';
import 'package:e_commerce_full_project/features/auth/data/models/auth_user.dart';
import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  final FirebaseFirestore _firestore;
 final CloudinaryService _cloudinaryService;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore ,   this._cloudinaryService,
);

  @override
 @override
Future<AuthUser> login(String email, String password) async {
  final credentials = await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  final user = credentials.user!;

  final userDoc = await _firestore
      .collection('users')
      .doc(user.uid)
      .get();

  final data = userDoc.data();

  print('LOGIN UID: ${user.uid}');
  print('USER DOCUMENT: $data');
  print('ROLE: ${data?['role']}');

  return AuthUser(
    uid: user.uid,
    email: user.email,
    displayname: data?['name'] ?? user.displayName,
    photoUrl: data?['photoUrl'] ?? user.photoURL,
  );
}
  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
  @override
  @override
Future<AuthUser?> checkAuth() async {
  final user = _firebaseAuth.currentUser;
  if (user == null) {
    return null;
  }
  final userDoc = await _firestore
      .collection('users')
      .doc(user.uid)
      .get();
  final data = userDoc.data();
  return AuthUser(
    uid: user.uid,
    email: user.email,
    displayname: data?['name'] ?? user.displayName,
    photoUrl: data?['photoUrl'] ?? user.photoURL,
  );
}
@override
Future<AuthUser> register({
  required String name,
  required String email,
  required String password,
  required String phone,
  File? profileImage,
}) async {
  User? user;

  try {
    final credentials =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    user = credentials.user;

    if (user == null) {
      throw Exception('Failed to create user');
    }

    await user.updateDisplayName(name);

    String? photoUrl;

    if (profileImage != null) {
      photoUrl = await _cloudinaryService.uploadProfileImage(
        profileImage,
      );
    }

    final userData = {
      'uid': user.uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
      if (photoUrl != null) 'photoUrl': photoUrl,
    };

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userData);

    await _firebaseAuth.signOut();

    log('Registration completed successfully');

    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayname: name,
      photoUrl: photoUrl,
    );
  } catch (e) {
    // لو Firebase Auth account اتعمل
    // لكن خطوة بعد كده فشلت، نمسحه.
    if (user != null) {
      try {
        await user.delete();
      } catch (_) {}
    }

    rethrow;
  }
}
  @override
  Future<AuthUser> loginWithGoogle() async {
   final GoogleSignIn googleSignIn = GoogleSignIn.instance;
   final GoogleSignInAccount googleUser =
       await googleSignIn.authenticate();
   final GoogleSignInAuthentication googleAuth =
       googleUser.authentication;
   final credential = GoogleAuthProvider.credential(
     idToken: googleAuth.idToken,
   );
   final UserCredential credentials =
       await _firebaseAuth.signInWithCredential(
     credential,
   );
   final User? user = credentials.user;
   if (user == null) {
     throw Exception('Google user is null');
   }
   return _handleSocialUser(user);
 } 

@override
Future<AuthUser> loginWithFacebook() async {
  final LoginResult result = await FacebookAuth.instance.login(
    permissions: ['email', 'public_profile'],
  );
  if (result.status != LoginStatus.success) {
    throw Exception(result.message ?? 'Facebook login failed');
  }
  final AccessToken? accessToken = result.accessToken;
  if (accessToken == null) {
    throw Exception('Facebook access token is null');
  }
  final OAuthCredential credential = FacebookAuthProvider.credential(
    accessToken.tokenString,
  );
  final UserCredential credentials =
      await _firebaseAuth.signInWithCredential(credential);
  final User? user = credentials.user;
  if (user == null) {
    throw Exception('Facebook user is null');
  }
  final userData = await FacebookAuth.instance.getUserData(
    fields: "name,email,picture.width(400)",
  );
  final facebookPhotoUrl =
      userData['picture']?['data']?['url'] as String? ?? user.photoURL ?? '';
  final userRef = _firestore.collection('users').doc(user.uid);
  final userDoc = await userRef.get();
  if (!userDoc.exists) {
    await userRef.set({
      'uid': user.uid,
      'name': user.displayName ?? userData['name'] ?? '',
      'email': user.email ?? userData['email'] ?? '',
      'phone': user.phoneNumber ?? '',
      'photoUrl': facebookPhotoUrl,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });
  } else {
    await userRef.update({'photoUrl': facebookPhotoUrl});
  }
  return AuthUser(
    uid: user.uid,
    email: user.email,
    displayname: user.displayName ?? userData['name'],
    photoUrl: facebookPhotoUrl,
  );
} 

  @override
  void resetError() {}
  Future<AuthUser> _handleSocialUser(User user) async {
  final userRef = _firestore.collection('users').doc(user.uid);
  final userDoc = await userRef.get();

  if (!userDoc.exists) {
    await userRef.set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'phone': user.phoneNumber ?? '',
      'photoUrl': user.photoURL ?? '',
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(), 
    });
  }

  return AuthUser(
    uid: user.uid,
    email: user.email,
    displayname: user.displayName,
    photoUrl: user.photoURL,
  );
} 
@override
Future<void> changePassword({
  required String oldPassword,
  required String newPassword,
}) async {
  final user = _firebaseAuth.currentUser;

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

  await user.reauthenticateWithCredential(credential);

  await user.updatePassword(newPassword);
}
@override
Future<void> sendPasswordResetEmail(String email) async {
  await _firebaseAuth.sendPasswordResetEmail(
    email: email.trim(),
  );
}
}
