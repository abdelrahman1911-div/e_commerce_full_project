import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/domain/repo/category_repo.dart';

class CategoryRepositoryImpl implements CategoryRepo {
  final FirebaseFirestore _firestore;

  CategoryRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('categories');

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final snapshot = await _categoriesCollection.get();

    return snapshot.docs.map((doc) {
      return CategoryModel.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }

  @override
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    final doc = await _categoriesCollection.doc(categoryId).get();

    if (!doc.exists) {
      return null;
    }

    return CategoryModel.fromJson({
      ...doc.data()!,
      'id': doc.id,
    });
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _categoriesCollection
        .doc(category.id)
        .set(category.toJson());
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _categoriesCollection
        .doc(category.id)
        .update(category.toJson());
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await _categoriesCollection
        .doc(categoryId)
        .delete();
  }
}