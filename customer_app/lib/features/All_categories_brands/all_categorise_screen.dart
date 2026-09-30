import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/cubit/category_cubit.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/cubit/category_state.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/screen/categorise_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('categories'.tr()),
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
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is CategorySuccess) {
            final categories = state.categories;

            if (categories.isEmpty) {
              return NoItemsWidget(
                mainText: 'No categories found',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                final category = categories[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      category.image,
                    ),
                  ),
                  title: Text(
                    category.name.tr(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoriseScreen(
                          selectedCategoryId: category.id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}