import 'package:e_commerce_admin/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/data/repos/category_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository)
      : super(CategoryInitial());

  Future<void> getAllCategories() async {
    emit(CategoryLoading());

    try {
      final categories =
          await _repository.getAllCategories();

      emit(
        CategorySuccess(categories),
      );
    } catch (e) {
      emit(
        CategoryError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> createCategory(
    AdminCategoryModel category,
  ) async {
    final currentCategories =
        _getCurrentCategories();

    emit(
      CategorySaving(
        currentCategories,
      ),
    );

    try {
      await _repository.createCategory(
        category,
      );

      final categories =
          await _repository.getAllCategories();

      emit(
        CategorySuccess(categories),
      );
    } catch (e) {
      emit(
        CategoryError(
          _getErrorMessage(e),
        ),
      );

      emit(
        CategorySuccess(
          currentCategories,
        ),
      );
    }
  }

  Future<void> updateCategory(
    AdminCategoryModel category,
  ) async {
    final currentCategories =
        _getCurrentCategories();

    emit(
      CategorySaving(
        currentCategories,
      ),
    );

    try {
      await _repository.updateCategory(
        category,
      );

      final categories =
          await _repository.getAllCategories();

      emit(
        CategorySuccess(categories),
      );
    } catch (e) {
      emit(
        CategoryError(
          _getErrorMessage(e),
        ),
      );

      emit(
        CategorySuccess(
          currentCategories,
        ),
      );
    }
  }

  Future<void> deleteCategory(
    String categoryId,
  ) async {
    final currentCategories =
        _getCurrentCategories();

    emit(
      CategoryDeleting(
        categories: currentCategories,
        categoryId: categoryId,
      ),
    );

    try {
      await _repository.deleteCategory(
        categoryId,
      );

      final categories =
          await _repository.getAllCategories();

      emit(
        CategorySuccess(categories),
      );
    } catch (e) {
      emit(
        CategoryError(
          _getErrorMessage(e),
        ),
      );

      emit(
        CategorySuccess(
          currentCategories,
        ),
      );
    }
  }

  List<AdminCategoryModel>
      _getCurrentCategories() {
    final currentState = state;

    if (currentState is CategorySuccess) {
      return currentState.categories;
    }

    if (currentState is CategorySaving) {
      return currentState.categories;
    }

    if (currentState is CategoryDeleting) {
      return currentState.categories;
    }

    return [];
  }

  String _getErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}
