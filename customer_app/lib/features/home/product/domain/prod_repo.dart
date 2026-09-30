import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';

abstract class ProductRepository {
  Future<void> uploadAllProducts(List<ProductModel> products);

  Future<List<ProductModel>> getAllProducts();

  Future<ProductModel?> getProductById(String productId);
}