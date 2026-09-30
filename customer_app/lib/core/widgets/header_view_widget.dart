import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/features/All_categories_brands/all_categorise_screen.dart';
import 'package:e_commerce_full_project/features/home/product/product_data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HeaderViewWidget extends StatelessWidget {
  String? ButtonText;
  String? Text1;
  bool? isCategories;
  HeaderViewWidget({super.key, this.isCategories, this.ButtonText, this.Text1});
  @override
  Widget build(BuildContext context) {
    final ProductData prodData = ProductData();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Text1 ?? 'Shop_by_brands'.tr(),
            style: AppTextStyles.headline(
              context,
            ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w700),
          ),
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.only(left: 10.w)),
            onPressed: () {
              if (isCategories == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen(),
                  ),
                );
              } else {
                context.push(AppRoutes.allItems, extra: prodData.productsList);
              }
            },
            child: Text(
              ButtonText ?? 'see_all'.tr(),
              style: AppTextStyles.headline(
                context,
              ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
