import 'dart:developer';

import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteLoaded extends FavouriteState {
  final List<ProductModel> favourites;
  FavouriteLoaded(this.favourites);
} 
class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());
  final List<ProductModel> favourites = [];
  void toggleFavourite(ProductModel product) {
    final exists = favourites.any(
      (item) => item.id == product.id,
    );
    if (exists) {
      log("Product Removed Successfully");
      favourites.removeWhere(
        (item) => item.id == product.id,
      );
    } else {
      log("Product Favourited Successfully");

      favourites.add(product);
    }
    emit(FavouriteLoaded(List.from(favourites)));
  }
  bool isFavourite(ProductModel product) {
    return favourites.any(
      (item) => item.id == product.id,
    );
  }
}
