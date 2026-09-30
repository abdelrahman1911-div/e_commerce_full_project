import 'package:e_commerce_admin/features/Categoriesscreen/data/models/category_model.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<AdminCategoryModel> categories;

  const CategorySuccess(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategorySaving extends CategoryState {
  final List<AdminCategoryModel> categories;

  const CategorySaving(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryDeleting extends CategoryState {
  final List<AdminCategoryModel> categories;
  final String categoryId;

  const CategoryDeleting({
    required this.categories,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [
        categories,
        categoryId,
      ];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}