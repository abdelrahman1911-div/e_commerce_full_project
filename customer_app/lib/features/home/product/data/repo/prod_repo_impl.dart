import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/features/home/product/domain/prod_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('products');

  @override
  Future<void> uploadAllProducts(List<ProductModel> products) async {
    final batch = _firestore.batch();
    for (final product in products) {
      final productRef = _productsCollection.doc(product.id);
      batch.set(
        productRef,
        product.toJson(),
      );
    }
    await batch.commit(); 
    print('✅ All products uploaded successfully');
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final snapshot = await _productsCollection.get();

    return snapshot.docs.map((doc) {
      return ProductModel.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList(); 

  }

  @override
  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _productsCollection.doc(productId).get();

    if (!doc.exists) {
      return null;
    }

    return ProductModel.fromJson({
      ...doc.data()!,
      'id': doc.id,
    });
  }
}