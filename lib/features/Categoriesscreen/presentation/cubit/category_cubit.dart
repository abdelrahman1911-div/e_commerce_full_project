import 'package:e_commerce_full_project/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/domain/repo/category_repo.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/cubit/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepo _categoryRepository;

  CategoryCubit(this._categoryRepository)
      : super(CategoryInitial());

  Future<void> getAllCategories() async {
    emit(CategoryLoading());

    try {
      final categories =
          await _categoryRepository.getAllCategories();

      emit(CategorySuccess(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> getCategoryById(String categoryId) async {
    emit(CategoryLoading());

    try {
      final category =
          await _categoryRepository.getCategoryById(categoryId);

      if (category == null) {
        emit(const CategoryError('Category not found'));
        return;
      }

      emit(CategoryByIdSuccess(category));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    emit(CategoryLoading());

    try {
      await _categoryRepository.addCategory(category);

      emit(CategoryOperationSuccess());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    emit(CategoryLoading());

    try {
      await _categoryRepository.updateCategory(category);

      emit(CategoryOperationSuccess());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    emit(CategoryLoading());

    try {
      await _categoryRepository.deleteCategory(categoryId);

      emit(CategoryOperationSuccess());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}