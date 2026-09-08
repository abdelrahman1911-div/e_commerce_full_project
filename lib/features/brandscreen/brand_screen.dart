import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/core/widgets/brand_categories_widget.dart';
import 'package:e_commerce_full_project/core/widgets/items_grid_view_widget.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/brand_data.dart';
import 'package:e_commerce_full_project/features/home/product/product_data.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandScreen extends StatefulWidget {
  final String? selectedCategoryName;
  const BrandScreen({super.key, this.selectedCategoryName});
  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  late String selectedBrand;
  final BrandData cat = BrandData();
  final ProductData productData = ProductData();
  @override
  void initState() {
    super.initState();
    selectedBrand = widget.selectedCategoryName ?? cat.brandsList[0].name;
  }

  List<ProductModel> get filteredProducts {
    return productData.productsList
        .where((product) => product.brand == selectedBrand)
        .toList();
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
      body: Column(
        children: [
          SizedBox(height: 12.h),
          SizedBox(
            height: 110.h,
            child: CustomListView(
              Scroll: Axis.horizontal,
              items: cat.brandsList,
              itemBuilder: (context, item, index) {
                final item = cat.brandsList[index];
                final isSelected = selectedBrand == item.name;
                return BrandCategoriesWidget( 
                  isCategories: false,
                  brandModel: item,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedBrand = item.name;
                    });
                  },
                );
              },
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
