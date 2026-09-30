import 'package:e_commerce_full_project/features/Categoriesscreen/data/models/category_model.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<CategoryModel> categories;

  const CategorySuccess(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryByIdSuccess extends CategoryState {
  final CategoryModel category;

  const CategoryByIdSuccess(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryOperationSuccess extends CategoryState {}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}