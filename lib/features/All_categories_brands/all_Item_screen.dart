import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllItemsScreen extends StatelessWidget {
  final List<ProductModel> productsList;

  const AllItemsScreen({
    super.key,
    required this.productsList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'all_items'.tr(),
        ),
      ),

      body: GridView.builder(
        padding: EdgeInsets.all(16.w),

        itemCount: productsList.length,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),

        itemBuilder: (context, index) {
          return ProductCardWidget(
            product: productsList[index],
          );
        },
      ),
    );
  }
}