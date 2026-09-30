import 'package:e_commerce_admin/features/product/data/model/product_model.dart';
import 'package:e_commerce_admin/features/product/domain/prod_repo.dart';
import 'package:e_commerce_admin/features/product/presentation/cubit/prod_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsCubit
    extends Cubit<ProductsState> {
  final ProductsRepository _repository;

  ProductsCubit(
    this._repository,
  ) : super(ProductsInitial());

  Future<void> getAllProducts() async {
    emit(
      ProductsLoading(),
    );

    try {
      final products =
          await _repository.getAllProducts();

      emit(
        ProductsSuccess(products),
      );
    } catch (e) {
      emit(
        ProductsError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> createProduct(
    AdminProductModel product,
  ) async {
    final current =
        _getCurrentProducts();

    emit(
      ProductsSaving(current),
    );

    try {
      await _repository.createProduct(
        product,
      );

      await getAllProducts();
    } catch (e) {
      emit(
        ProductsError(
          e.toString(),
        ),
      );

      emit(
        ProductsSuccess(current),
      );
    }
  }

  Future<void> updateProduct(
    AdminProductModel product,
  ) async {
    final current =
        _getCurrentProducts();

    emit(
      ProductsSaving(current),
    );

    try {
      await _repository.updateProduct(
        product,
      );

      await getAllProducts();
    } catch (e) {
      emit(
        ProductsError(
          e.toString(),
        ),
      );

      emit(
        ProductsSuccess(current),
      );
    }
  }

  Future<void> deleteProduct(
    String productId,
  ) async {
    final current =
        _getCurrentProducts();

    emit(
      ProductsDeleting(
        products: current,
        productId: productId,
      ),
    );

    try {
      await _repository.deleteProduct(
        productId,
      );

      await getAllProducts();
    } catch (e) {
      emit(
        ProductsError(
          e.toString(),
        ),
      );

      emit(
        ProductsSuccess(current),
      );
    }
  }

  List<AdminProductModel>
      _getCurrentProducts() {
    final current = state;

    if (current is ProductsSuccess) {
      return current.products;
    }

    if (current is ProductsSaving) {
      return current.products;
    }

    if (current is ProductsDeleting) {
      return current.products;
    }

    return [];
  }
}