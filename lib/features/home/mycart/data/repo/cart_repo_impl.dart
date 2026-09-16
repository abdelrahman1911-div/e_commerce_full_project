import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';
import 'package:e_commerce_full_project/features/home/mycart/domain/cart_repo.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';

class CartRepositoryImpl implements CartRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CartRepositoryImpl(
    this._firestore,
    this._firebaseAuth,
  );

  CollectionReference<Map<String, dynamic>> get _cartCollection {
    final uid = _firebaseAuth.currentUser?.uid;

    if (uid == null) {
      throw Exception('No authenticated user found.');
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cart');
  }

  CollectionReference<Map<String, dynamic>> get _productsCollection {
    return _firestore.collection('products');
  }

  // ============================================================
  // CREATE CART ITEM ID
  // ============================================================

  String _createCartItemId({
    required String productId,
    String? selectedColor,
    String? selectedSize,
  }) {
    final color = selectedColor?.trim().isNotEmpty == true
        ? selectedColor!.trim().toLowerCase().replaceAll(' ', '_')
        : 'no_color';

    final size = selectedSize?.trim().isNotEmpty == true
        ? selectedSize!.trim().toLowerCase().replaceAll(' ', '_')
        : 'no_size';

    return '${productId}_${color}_$size';
  }

  // ============================================================
  // GET CART
  // ============================================================

  @override
  Future<List<CartItemModel>> getCart() async {
    final cartSnapshot = await _cartCollection.get();
    final List<CartItemModel> cartItems = [];

    for (final cartDoc in cartSnapshot.docs) {
      final data = cartDoc.data();

      final productId = data['productId']?.toString();

      if (productId == null || productId.isEmpty) {
        continue;
      }

      final productDoc =
          await _productsCollection.doc(productId).get();

      if (!productDoc.exists) {
        continue;
      }

      final productData = productDoc.data();

      if (productData == null) {
        continue;
      }

      final product = ProductModel.fromJson({
        ...productData,
        'id': productDoc.id,
      });

      final cartItem = CartItemModel.fromJson(
        cartItemId: cartDoc.id,
        product: product,
        json: data,
      );

      cartItems.add(cartItem);
    }

    return cartItems;
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  @override
  Future<void> addToCart(
    String productId,
    String? selectedColor,
    String? selectedSize,
  ) async {
    final cartItemId = _createCartItemId(
      productId: productId,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
    );

    final cartRef = _cartCollection.doc(cartItemId);

    final cartDoc = await cartRef.get();

    if (cartDoc.exists) {
      final currentQuantity = _toInt(
        cartDoc.data()?['quantity'],
      );

      await cartRef.update({
        'quantity': currentQuantity + 1,
      });

      return;
    }

    await cartRef.set({
      'productId': productId,
      'quantity': 1,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
    });
  }

  // ============================================================
  // INCREASE
  // ============================================================

  @override
  Future<void> increaseQuantity(
    String cartItemId,
  ) async {
    final cartRef = _cartCollection.doc(cartItemId);

    await _firestore.runTransaction(
      (transaction) async {
        final snapshot = await transaction.get(cartRef);

        if (!snapshot.exists) {
          throw Exception(
            'Cart item not found: $cartItemId',
          );
        }

        final data = snapshot.data();

        if (data == null) {
          throw Exception(
            'Cart item data is empty.',
          );
        }

        final currentQuantity = _toInt(
          data['quantity'],
        );

        transaction.update(
          cartRef,
          {
            'quantity': currentQuantity + 1,
          },
        );
      },
    );
  }

  // ============================================================
  // DECREASE
  // ============================================================

  @override
  Future<void> decreaseQuantity(
    String cartItemId,
  ) async {
    final cartRef = _cartCollection.doc(cartItemId);

    await _firestore.runTransaction(
      (transaction) async {
        final snapshot = await transaction.get(cartRef);

        if (!snapshot.exists) {
          return;
        }

        final data = snapshot.data();

        if (data == null) {
          return;
        }

        final currentQuantity = _toInt(
          data['quantity'],
        );

        if (currentQuantity <= 1) {
          transaction.delete(cartRef);
        } else {
          transaction.update(
            cartRef,
            {
              'quantity': currentQuantity - 1,
            },
          );
        }
      },
    );
  }

  // ============================================================
  // REMOVE
  // ============================================================

  @override
  Future<void> removeFromCart(
    String cartItemId,
  ) async {
    await _cartCollection
        .doc(cartItemId)
        .delete();
  }

  // ============================================================
  // CLEAR
  // ============================================================

  @override
  Future<void> clearCart() async {
    final snapshot = await _cartCollection.get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // ============================================================
  // TO INT
  // ============================================================

  int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        1;
  }
}
