import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/features/home/favourite/domain/favourite_repo.dart';

class FavouriteRepositoryImpl implements FavouriteRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FavouriteRepositoryImpl(
    this._firestore,
    this._firebaseAuth,
  );

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('products');

  CollectionReference<Map<String, dynamic>> get _favoritesCollection {
    final uid = _firebaseAuth.currentUser?.uid;

    if (uid == null) {
      throw Exception('No authenticated user found.');
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');
  }

  @override
  Future<void> addFavorite(String productId) async {
    await _favoritesCollection.doc(productId).set({
      'productId': productId,
    });
  }

  @override
  Future<void> removeFavorite(String productId) async {
    await _favoritesCollection.doc(productId).delete();
  }

  @override
  Future<List<ProductModel>> getFavorites() async {
    final favoritesSnapshot = await _favoritesCollection.get();

    if (favoritesSnapshot.docs.isEmpty) {
      return [];
    }

    final List<ProductModel> favorites = [];

    for (final favoriteDoc in favoritesSnapshot.docs) {
      final productId = favoriteDoc.id;

      final productDoc =
          await _productsCollection.doc(productId).get();

      if (!productDoc.exists) {
        continue;
      }

      final product = ProductModel.fromJson({
        ...productDoc.data()!,
        'id': productDoc.id,
      });

      favorites.add(product);
    }

    return favorites;
  }
}