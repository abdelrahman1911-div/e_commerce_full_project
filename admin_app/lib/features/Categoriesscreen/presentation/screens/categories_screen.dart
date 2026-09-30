import 'package:e_commerce_admin/core/router/app_routes.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/presentation/cubit/category_cubit.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/presentation/cubit/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Future<void> _showDeleteDialog(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text(
            'Are you sure you want to delete "$categoryName"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    if (!context.mounted) return;

    await context.read<CategoryCubit>().deleteCategory(categoryId);
  }

  void _editCategory(
    BuildContext context,
    dynamic category,
  ) { 
    context.push(AppRoutes.editCategory , extra: category); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit ${category.name}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CategoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<CategoryCubit>()
                            .getAllCategories();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CategorySuccess) {
            if (state.categories.isEmpty) {
              return RefreshIndicator(
                onRefresh: () {
                  return context
                      .read<CategoryCubit>()
                      .getAllCategories();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 250),
                    Center(
                      child: Text(
                        'No categories found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () {
                return context
                    .read<CategoryCubit>()
                    .getAllCategories();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: category.image.isNotEmpty
                                  ? Image.network(
                                      category.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 35,
                                          ),
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child:
                                                CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.category_outlined,
                                        size: 35,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              category.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Edit',
                              onPressed: () {
                                _editCategory(
                                  context,
                                  category,
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                              ),
                            ),

                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () {
                              _showDeleteDialog(
                                context,
                                category.id,
                                category.name,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ), 
                          
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ), 
      floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    context.push(AppRoutes.createCategory);
  },
  icon: const Icon(Icons.add),
  label: const Text('Add Category'),
),
    );
  }
}