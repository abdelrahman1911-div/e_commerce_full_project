import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/domain/repos/brands_repo.dart';
import 'package:flutter/material.dart';

class BrandRepositoryImpl implements BrandRepository {
  final FirebaseFirestore _firebaseFirestore;

  BrandRepositoryImpl(this._firebaseFirestore);

  CollectionReference<Map<String, dynamic>> get _brandsCollection =>
      _firebaseFirestore.collection('brands');

  @override
  Future<List<BrandModel>> getAllBrands() async {
    final snapshot = await _brandsCollection.get();
    for (final doc in snapshot.docs) {
      debugPrint('==============================');
      debugPrint('DOC ID: ${doc.id}');
      debugPrint('RAW DATA: ${doc.data()}');
    }
    return snapshot.docs.map((doc) {
      return BrandModel.fromJson({...doc.data(), 'id': doc.id});
    }).toList();
  }

  @override
  Future<BrandModel?> getBrandById(String brandId) async {
    final doc = await _brandsCollection.doc(brandId).get();
    if (!doc.exists) {
      return null;
    }
    return BrandModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  @override
  Future<void> addBrand(BrandModel brand) async {
    await _brandsCollection.doc(brand.id).set(brand.toJson());
  }

  @override
  Future<void> updateBrand(BrandModel brand) async {
    await _brandsCollection.doc(brand.id).update(brand.toJson());
  }

  @override
  Future<void> deleteBrand(String brandId) async {
    await _brandsCollection.doc(brandId).delete();
  }
}
