import 'package:e_commerce_full_project/features/home/product/domain/prod_repo.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/cubit/prod_state.dart';
import 'package:e_commerce_full_project/features/home/product/product_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit(this._productRepository) : super(ProductInitial());

  Future<void> uploadAllProducts() async {
    emit(ProductLoading());

    try {
      await _productRepository.uploadAllProducts(
        ProductData().productsList,
      );

      emit(ProductUploadSuccess());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getAllProducts() async {
    emit(ProductLoading());

    try {
      final products = await _productRepository.getAllProducts();

      emit(ProductSuccess(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}