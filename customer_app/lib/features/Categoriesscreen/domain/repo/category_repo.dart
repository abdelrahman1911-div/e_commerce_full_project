import 'package:e_commerce_full_project/features/Categoriesscreen/data/models/category_model.dart';

abstract class CategoryRepo {
  Future <List<CategoryModel>> getAllCategories (); 
  Future<CategoryModel?> getCategoryById(String categoryId);
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String categoryId); 
}