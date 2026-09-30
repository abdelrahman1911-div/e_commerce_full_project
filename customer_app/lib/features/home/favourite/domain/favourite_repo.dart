
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';

abstract class FavouriteRepository { 
  
  Future<List<ProductModel>> getFavorites();

  Future<void> addFavorite(String productId);

  Future<void> removeFavorite(String productId);
}