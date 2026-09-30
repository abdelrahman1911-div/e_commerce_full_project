import 'dart:developer';

import 'package:e_commerce_full_project/features/home/favourite/domain/favourite_repo.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteLoaded extends FavouriteState {
  final List<ProductModel> favourites;

  FavouriteLoaded(this.favourites);
}

class FavouriteError extends FavouriteState {
  final String message;

  FavouriteError(this.message);
}

class FavouriteCubit extends Cubit<FavouriteState> {
  final FavouriteRepository _favouriteRepository;

  FavouriteCubit(this._favouriteRepository)
      : super(FavouriteInitial());

  List<ProductModel> favourites = [];

  // ===========================================================
  // LOAD FAVORITES
  // ===========================================================

  Future<void> getFavorites() async {
    emit(FavouriteLoading());

    try {
      final loadedFavorites =
          await _favouriteRepository.getFavorites();

      favourites = loadedFavorites;

      emit(
        FavouriteLoaded(
          List<ProductModel>.from(favourites),
        ),
      );

      log(
        'Favorites loaded successfully: ${favourites.length}',
      );
    } catch (e) {
      log('Failed to load favorites: $e');

      emit(
        FavouriteError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> toggleFavourite(ProductModel product) async {
    final exists = isFavourite(product);

    try {
      if (exists) {
        await _favouriteRepository.removeFavorite(product.id);

        favourites.removeWhere(
          (item) => item.id == product.id,
        );

        log('Product Removed Successfully');
      } else {
        await _favouriteRepository.addFavorite(product.id);

        favourites.add(product);

        log('Product Favourited Successfully');
      }

      emit(
        FavouriteLoaded(
          List<ProductModel>.from(favourites),
        ),
      );
    } catch (e) {
      log('Favourite operation failed: $e');

      emit(
        FavouriteError(
          e.toString(),
        ),
      );
    }
  }
  bool isFavourite(ProductModel product) {
    return favourites.any(
      (item) => item.id == product.id,
    );
  }
}