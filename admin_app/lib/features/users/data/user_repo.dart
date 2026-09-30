import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../firebase_options.dart';
import 'models/admin_user_model.dart';

abstract class UsersRepository {
  Future<List<AdminUserModel>> getAllUsers();

  Future<void> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  });

  Future<void> deleteUser(String userId);
}

class UsersRepositoryImpl implements UsersRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  UsersRepositoryImpl(
    this._firestore,
    this._firebaseAuth,
  );

  CollectionReference<Map<String, dynamic>>
      get _usersCollection =>
          _firestore.collection('users');

  @override
  Future<List<AdminUserModel>> getAllUsers() async {
    final snapshot =
        await _usersCollection.get();
    final users = <AdminUserModel>[];
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final ordersSnapshot =
          await _firestore
              .collection('users')
              .doc(doc.id)
              .collection('orders')
              .count()
              .get();
      users.add(
        AdminUserModel.fromJson({
          ...data,
          'uid': doc.id,
          'ordersCount':
              ordersSnapshot.count ?? 0,
        }),
      );
    }
    return users;
  }

  @override
  Future<void> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    FirebaseApp? secondaryApp;
    try {
      try {
        secondaryApp =
            Firebase.app('adminUserCreator');
      } catch (_) {
        secondaryApp =
            await Firebase.initializeApp(
          name: 'adminUserCreator',
          options:
              DefaultFirebaseOptions
                  .currentPlatform,
        );
      }
      final secondaryAuth =
          FirebaseAuth.instanceFor(
        app: secondaryApp,
      );
      final credential =
          await secondaryAuth
              .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception(
          'Failed to create user.',
        );
      }
      await user.updateDisplayName(
        name.trim(),
      );
      if (role == 'driver') {
      await _firestore
          .collection('drivers')
          .doc(user.uid)
          .set({
        'id': user.uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'role': 'driver',
        'isOnline': false,
        'isAvailable': true,
        'currentOrderId': '',
        'latitude': null,
        'longitude': null,
        'createdAt': FieldValue.serverTimestamp(),
        'assignedAt': null,
      });
    }else {
      await _firestore
      .collection('users')
      .doc(user.uid)
      .set({
      'email': email.trim(),
      'displayname': name.trim(),
      'phone': phone.trim(),
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      });
      if (role == 'admin') {
        await _firestore
            .collection('admins')
            .doc(user.uid)
            .set({
          'email': email.trim(),
          'displayname': name.trim(),
          'phone': phone.trim(),
          'role': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
      await secondaryAuth.signOut();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
  @override
  Future<void> deleteUser(
    String userId,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .delete();
  }
}