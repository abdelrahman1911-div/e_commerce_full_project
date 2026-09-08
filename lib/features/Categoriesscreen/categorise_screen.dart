import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/core/widgets/brand_categories_widget.dart';
import 'package:e_commerce_full_project/core/widgets/items_grid_view_widget.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/categories_data.dart';
import 'package:e_commerce_full_project/features/home/product/product_data.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriseScreen extends StatefulWidget {
  final String? selectedCategoryName;

  const CategoriseScreen({super.key, this.selectedCategoryName});

  @override
  State<CategoriseScreen> createState() => _CategoriseScreenState();
}

class _CategoriseScreenState extends State<CategoriseScreen> {
  late String selectedCategory;
  final CategoriesData cat = CategoriesData();
  final ProductData productData = ProductData();
  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.selectedCategoryName ?? cat.categoriesList[0].name;
  }

  List<ProductModel> get filteredProducts {
    return productData.productsList
        .where((product) => product.category == selectedCategory)
        .toList();
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
      body: Column(
        children: [
          SizedBox(height: 12.h),
          SizedBox(
            height: 110.h,
            child: CustomListView(
              items: cat.categoriesList,
              itemBuilder: (context, item, index) {
                final category = cat.categoriesList[index];
                final isSelected = selectedCategory == category.name;
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
          Divider(height: 20.h, thickness: 1, color: Colors.grey[300]),
          Expanded(
            child: filteredProducts.isEmpty
                ? NoItemsWidget(mainText: 'no_products_in_category'.tr())
                : ItemsGridViewWidget(productList: filteredProducts),
          ),
        ],
      ),
    );
  }
}
