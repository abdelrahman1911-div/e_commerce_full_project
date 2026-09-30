import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/auth/data/models/auth_user.dart';
import 'package:e_commerce_admin/features/auth/domain/repos/auth_repos.dart';
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

  final adminDoc = await _firestore
      .collection('admins')
      .doc(user.uid)
      .get();

  print('ADMIN DOC EXISTS: ${adminDoc.exists}');
  print('ADMIN DOC DATA: ${adminDoc.data()}');

  if (!adminDoc.exists) {
    await _firebaseAuth.signOut();

    throw FirebaseAuthException(
      code: 'not-admin',
      message:
          'No admin document found for UID: ${user.uid}',
    );
  }

  final data = adminDoc.data();
  final role = data?['role'];

  print('ADMIN ROLE: $role');

  if (role != 'admin') {
    await _firebaseAuth.signOut();

    throw FirebaseAuthException(
      code: 'not-admin',
      message: 'Admin role is invalid: $role',
    );
  }

  return AuthUser(
    uid: user.uid,
    email: user.email,
    displayName: data?['name'] ?? user.displayName,
    role: role,
  );
}

  @override
  Future<AuthUser?> checkAuth() async {
    final User? user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    final adminDoc = await _firestore
        .collection('admins')
        .doc(user.uid)
        .get();

    if (!adminDoc.exists) {
      await _firebaseAuth.signOut();
      return null;
    }

    final data = adminDoc.data();

    final role = data?['role'];

    if (role != 'admin') {
      await _firebaseAuth.signOut();
      return null;
    }

    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: data?['name'] ?? user.displayName,
      role: role,
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