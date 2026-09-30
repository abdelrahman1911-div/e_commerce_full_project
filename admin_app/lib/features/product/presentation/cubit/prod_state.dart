import 'package:e_commerce_admin/features/product/data/model/product_model.dart';
import 'package:equatable/equatable.dart';
abstract class ProductsState
    extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial
    extends ProductsState {}

class ProductsLoading
    extends ProductsState {}

class ProductsSuccess
    extends ProductsState {
  final List<AdminProductModel> products;

  const ProductsSuccess(
    this.products,
  );

  @override
  List<Object?> get props => [
        products,
      ];
}

class ProductsSaving
    extends ProductsState {
  final List<AdminProductModel> products;

  const ProductsSaving(
    this.products,
  );

  @override
  List<Object?> get props => [
        products,
      ];
}

class ProductsDeleting
    extends ProductsState {
  final List<AdminProductModel> products;
  final String productId;

  const ProductsDeleting({
    required this.products,
    required this.productId,
  });

  @override
  List<Object?> get props => [
        products,
        productId,
      ];
}

class ProductsError
    extends ProductsState {
  final String message;

  const ProductsError(
    this.message,
  );

  @override
  List<Object?> get props => [
        message,
      ];
}