import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<AdminCategoryModel>> getAllCategories();

  Future<void> createCategory(
    AdminCategoryModel category,
  );

  Future<void> updateCategory(
    AdminCategoryModel category,
  );

  Future<void> deleteCategory(
    String categoryId,
  );
}

class CategoryRepositoryImpl
    implements CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepositoryImpl(
    this._firestore,
  );

  CollectionReference<Map<String, dynamic>>
      get _categoriesCollection =>
          _firestore.collection('categories');

  @override
  Future<List<AdminCategoryModel>>
      getAllCategories() async {
    final snapshot =
        await _categoriesCollection.get();

    final categories = snapshot.docs.map((doc) {
      final data = doc.data();

      return AdminCategoryModel.fromJson({
        ...data,
        'id': doc.id,
      });
    }).toList();

    categories.sort(
      (a, b) => a.name
          .toLowerCase()
          .compareTo(
            b.name.toLowerCase(),
          ),
    );

    return categories;
  }

  @override
  Future<void> createCategory(
    AdminCategoryModel category,
  ) async {
    final doc =
        _categoriesCollection.doc();

    await doc.set({
      'id': doc.id,
      'name': category.name,
      'image': category.image,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateCategory(
    AdminCategoryModel category,
  ) async {
    if (category.id.isEmpty) {
      throw Exception(
        'Category ID is required.',
      );
    }

    await _categoriesCollection
        .doc(category.id)
        .update({
      'name': category.name,
      'image': category.image,
    });
  }

  @override
  Future<void> deleteCategory(
    String categoryId,
  ) async {
    if (categoryId.isEmpty) {
      throw Exception(
        'Category ID is required.',
      );
    }

    await _categoriesCollection
        .doc(categoryId)
        .delete();
  }
}
