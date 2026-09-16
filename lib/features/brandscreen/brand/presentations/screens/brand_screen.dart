import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/core/widgets/brand_categories_widget.dart';
import 'package:e_commerce_full_project/core/widgets/items_grid_view_widget.dart';

import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_cubit.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_state.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/cubit/prod_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/cubit/prod_state.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandScreen extends StatefulWidget {
  final String? selectedBrandId;

  const BrandScreen({super.key, this.selectedBrandId});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  String? selectedBrandId;

  @override
  void initState() {
    super.initState();

    selectedBrandId = widget.selectedBrandId;

    context.read<BrandCubit>().getAllBrands();

    context.read<ProductCubit>().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop by Brand'.tr(),
          style: AppTextStyles.headline(
            context,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),

      body: BlocBuilder<BrandCubit, BrandState>(
        builder: (context, brandState) {
          if (brandState is BrandLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (brandState is BrandError) {
            return Center(
              child: Text(brandState.message, textAlign: TextAlign.center),
            );
          }

          if (brandState is BrandSuccess) {
            final brands = brandState.brands;

            if (brands.isEmpty) {
              return NoItemsWidget(mainText: 'no_items'.tr());
            }

            // لو مفيش Brand متحدد
            // اختار أول Brand
            if (selectedBrandId == null ||
                !brands.any((brand) => brand.id == selectedBrandId)) {
              selectedBrandId = brands.first.id;
            }

            return Column(
              children: [
                SizedBox(height: 12.h),

                // =========================
                // Brands
                // =========================
                SizedBox(
                  height: 110.h,
                  child: CustomListView(
                    Scroll: Axis.horizontal,
                    items: brands,
                    itemBuilder: (context, item, index) {
                      final isSelected = selectedBrandId == item.id;

                      return BrandCategoriesWidget(
                        isCategories: false,
                        brandModel: item,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedBrandId = item.id;
                          });
                        },
                      );
                    },
                  ),
                ),

                Divider(height: 20.h, thickness: 1, color: Colors.grey[300]),

                // =========================
                // Products
                // =========================
                Expanded(
                  child: BlocBuilder<ProductCubit, ProductState>(
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
                        final selectedBrand = brands.firstWhere(
                          (brand) => brand.id == selectedBrandId,
                        );

                        final products = productState.products
                            .where(
                              (product) => product.brandId == selectedBrandId,
                            )
                            .toList();

                        if (products.isEmpty) {
                          return NoItemsWidget(
                            mainText: 'no_products_in_category'.tr(),
                          );
                        }
                        return ItemsGridViewWidget(
                          productList: products,
                          brandModel: selectedBrand,
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
      ),
    );
  }
}
