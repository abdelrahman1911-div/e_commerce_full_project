import 'package:e_commerce_full_project/core/widgets/product_card.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemsGridViewWidget extends StatelessWidget {
  final List<ProductModel> productList;
  final BrandModel? brandModel;
  final ScrollPhysics? scroll;
  final SliverGridDelegate? gridDelegate;

  const ItemsGridViewWidget({
    super.key,
    required this.productList,
    this.gridDelegate,
    this.scroll,
    this.brandModel,
  });

  @override
  Widget build(BuildContext context) {
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
        return ProductCardWidget(
          product: productList[index],
          brandName: brandModel?.name,
        );
      },
    );
  }
}