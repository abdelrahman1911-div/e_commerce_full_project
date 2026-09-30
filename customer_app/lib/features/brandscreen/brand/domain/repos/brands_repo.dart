import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
abstract class BrandRepository {
   Future<List<BrandModel>> getAllBrands();
   Future<BrandModel?> getBrandById(String brandId);
   Future<void> addBrand(BrandModel brand); 
   Future<void> updateBrand(BrandModel brand); 
   Future<void> deleteBrand(String brandId);
}