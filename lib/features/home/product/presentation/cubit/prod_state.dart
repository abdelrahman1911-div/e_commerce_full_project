import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductUploadSuccess extends ProductState {}

class ProductSuccess extends ProductState {
  final List<ProductModel> products;

  const ProductSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}