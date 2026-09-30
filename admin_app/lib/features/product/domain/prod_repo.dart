import '../data/model/product_model.dart';

abstract class ProductsRepository {
  Future<List<AdminProductModel>> getAllProducts();

  Future<void> createProduct(
    AdminProductModel product,
  );

  Future<void> updateProduct(
    AdminProductModel product,
  );

  Future<void> deleteProduct(
    String productId,
  );
}