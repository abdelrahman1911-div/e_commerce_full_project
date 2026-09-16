import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/core/widgets/brand_categories_widget.dart';
import 'package:e_commerce_full_project/core/widgets/items_grid_view_widget.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/cubit/category_cubit.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/cubit/category_state.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_cubit.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_state.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/cubit/prod_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/cubit/prod_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriseScreen extends StatefulWidget {
  final String? selectedCategoryName;

  const CategoriseScreen({super.key, this.selectedCategoryName});

  @override
  State<CategoriseScreen> createState() => _CategoriseScreenState();
}

class _CategoriseScreenState extends State<CategoriseScreen> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategoryName;
    context.read<CategoryCubit>().getAllCategories();
    context.read<ProductCubit>().getAllProducts(); 
      context.read<BrandCubit>().getAllBrands();

  }

  List<ProductModel> getFilteredProducts(List<ProductModel> products) {
    if (selectedCategory == null) {
      return products;
    }

    return products.where((product) {
      return product.category.trim().toLowerCase() ==
          selectedCategory!.trim().toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'shop_by_category'.tr(),
          style: AppTextStyles.headline(
            context,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, categoryState) {
          if (categoryState is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (categoryState is CategoryError) {
            return Center(
              child: Text(categoryState.message, textAlign: TextAlign.center),
            );
          }

          if (categoryState is CategorySuccess) {
            final List<CategoryModel> categories = categoryState.categories;

            if (categories.isEmpty) {
              return NoItemsWidget(mainText: 'no_items'.tr());
            }

            if (selectedCategory == null) {
              selectedCategory = categories.first.name;
            }

            return BlocBuilder<ProductCubit, ProductState>(
              builder: (context, productState) {
                if (productState is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productState is ProductError) {
                  return Center(
                    child: Text(
                      productState.message,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (productState is ProductSuccess) {
                  final List<ProductModel> products = productState.products;

                  final filteredProducts = getFilteredProducts(products);

                  return Column(
                    children: [
                      SizedBox(height: 12.h),

                      SizedBox(
                        height: 110.h,
                        child: CustomListView(
                          items: categories,
                          itemBuilder: (context, item, index) {
                            final category = item;

                            final isSelected =
                                selectedCategory == category.name;

                            return BrandCategoriesWidget(
                              isSelected: isSelected,
                              categoryModel: category,
                              isCategories: true,
                              onTap: () {
                                setState(() {
                                  selectedCategory = category.name;
                                });
                              },
                            );
                          },
                          Scroll: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),

                      Divider(
                        height: 20.h,
                        thickness: 1,
                        color: Colors.grey[300],
                      ),

                      Expanded(
                        child: filteredProducts.isEmpty
                            ? NoItemsWidget(
                                mainText: 'no_products_in_category'.tr(),
                              )
                            : 
BlocBuilder<BrandCubit, BrandState>(
  builder: (context, brandState) {
    if (brandState is BrandLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (brandState is BrandError) {
      return Center(
        child: Text(brandState.message),
      );
    }

    if (brandState is BrandSuccess) {
      return ItemsGridViewWidget(
        productList: filteredProducts,
        brands: brandState.brands,
      );
    }

    return const SizedBox.shrink();
  },
),

                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
