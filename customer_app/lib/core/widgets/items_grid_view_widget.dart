import 'package:e_commerce_full_project/core/widgets/product_card.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemsGridViewWidget extends StatelessWidget {
  final List<ProductModel> productList;
  final List<BrandModel> brands;
  final ScrollPhysics? scroll;
  final SliverGridDelegate? gridDelegate;

  const ItemsGridViewWidget({
    super.key,
    required this.productList,
    required this.brands,
    this.gridDelegate,
    this.scroll,
  });

  @override
  Widget build(BuildContext context) {
    // brand id -> brand name
    final Map<String, String> brandNames = {
      for (final brand in brands) brand.id: brand.name,
    };

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      physics: scroll ?? const BouncingScrollPhysics(),
      gridDelegate:
          gridDelegate ??
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
      itemCount: productList.length,
      itemBuilder: (context, index) {
        final product = productList[index];

        final String brandName =
            brandNames[product.brand] ?? product.brand;

        return ProductCardWidget(
          product: product,
          brandName: brandName,
        );
      },
    );
  }
}
