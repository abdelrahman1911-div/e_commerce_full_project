import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/auth/data/models/auth_user.dart';
import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<AuthUser> login(String email, String password) async {
    final credentials = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credentials.user!;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    final data = userDoc.data();

    print('LOGIN UID: ${user.uid}');
    print('USER DOCUMENT: $data');
    print('ROLE: ${data?['role']}');

    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      role: data?['role'] ?? 'user',
    );
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<AuthUser?> checkAuth() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final data = userDoc.data();

    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      role: data?['role'] ?? "user",
    );
  }

  @override
  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,

      password: password,
    );
    final user = credentials.user!;

    await user.updateDisplayName(name);

    final userData = {
      'uid': user.uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('users').doc(user.uid).set(userData);

    await _firebaseAuth.signOut();

    log("Go to login :)");

    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: name,
      photoUrl: user.photoURL,
      role: 'user',
    );
  }

  @override
  void resetError() {}
}
