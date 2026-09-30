import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/brand/data/models/brand_model.dart';

abstract class BrandRepository {
  Future<List<AdminBrandModel>> getAllBrands();

  Future<void> createBrand(
    AdminBrandModel brand,
  );

  Future<void> updateBrand(
    AdminBrandModel brand,
  );

  Future<void> deleteBrand(
    String brandId,
  );
}

class BrandRepositoryImpl
    implements BrandRepository {
  final FirebaseFirestore _firestore;

  BrandRepositoryImpl(
    this._firestore,
  );

  CollectionReference<Map<String, dynamic>>
      get _brandsCollection =>
          _firestore.collection('brands');

  @override
  Future<List<AdminBrandModel>>
      getAllBrands() async {
    final snapshot =
        await _brandsCollection.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return AdminBrandModel.fromJson({
        ...data,
        'id': doc.id,
      });
    }).toList();
  }

  @override
  Future<void> createBrand(
    AdminBrandModel brand,
  ) async {
    final doc =
        _brandsCollection.doc();

    await doc.set({
      ...brand.toJson(),
      'id': doc.id,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateBrand(
    AdminBrandModel brand,
  ) async {
    await _brandsCollection
        .doc(brand.id)
        .update(
      brand.toJson(),
    );
  }

  @override
  Future<void> deleteBrand(
    String brandId,
  ) async {
    await _brandsCollection
        .doc(brandId)
        .delete();
  }
}