import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/product/data/model/product_model.dart';
import 'package:e_commerce_admin/features/product/domain/prod_repo.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final FirebaseFirestore _firestore;

  ProductsRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('products');

  CollectionReference<Map<String, dynamic>> get _brandsCollection =>
      _firestore.collection('brands');

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('categories');

  @override
  Future<List<AdminProductModel>> getAllProducts() async {
    final results = await Future.wait([
      _productsCollection.get(),
      _brandsCollection.get(),
      _categoriesCollection.get(),
    ]);

    final productsSnapshot = results[0] as QuerySnapshot<Map<String, dynamic>>;

    final brandsSnapshot = results[1] as QuerySnapshot<Map<String, dynamic>>;

    final categoriesSnapshot =
        results[2] as QuerySnapshot<Map<String, dynamic>>;

    final brandNames = <String, String>{};

    for (final doc in brandsSnapshot.docs) {
      final data = doc.data();

      final brandId = data['id']?.toString() ?? doc.id;

      final brandName = data['name']?.toString() ?? '';

      brandNames[brandId] = brandName;
    }

    final categoryNames = <String, String>{};

    for (final doc in categoriesSnapshot.docs) {
      final data = doc.data();

      final categoryId = data['id']?.toString() ?? doc.id;

      final categoryName = data['name']?.toString() ?? '';

      categoryNames[categoryId] = categoryName;
    }

    return productsSnapshot.docs.map((doc) {
      final data = doc.data();

      final brandId = data['brandId']?.toString() ?? '';

      final categoryId = data['categoryId']?.toString() ?? '';

      return AdminProductModel.fromJson({
        ...data,
        'id': doc.id,
        'brandName': brandNames[brandId] ?? '',
        'categoryName': categoryNames[categoryId] ?? '',
      });
    }).toList();
  }

  @override
  Future<void> createProduct(AdminProductModel product) async {
    final doc = _productsCollection.doc();

    final data = product.toJson();

    data['id'] = doc.id;

    data['createdAt'] = FieldValue.serverTimestamp();

    await doc.set(data);
  }

  @override
  Future<void> updateProduct(AdminProductModel product) async {
    await _productsCollection.doc(product.id).update(product.toJson());
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _productsCollection.doc(productId).delete();
  }
}
