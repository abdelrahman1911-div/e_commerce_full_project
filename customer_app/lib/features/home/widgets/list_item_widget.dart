import 'package:e_commerce_full_project/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/screen/categorise_screen.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/screens/brand_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListItemWidget extends StatelessWidget {
  final BrandModel? brand;
  final bool isCategories;
  final CategoryModel? catData;

  const ListItemWidget({
    super.key,
    this.catData,
    this.brand,
    required this.isCategories,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (isCategories) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriseScreen(
                      selectedCategoryId: catData!.id,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrandScreen(
                      selectedBrandId: brand!.name,
                    ),
                  ),
                );
              }
            },
            child: Container(
              width: 55.w,
              height: 55.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: ClipOval(
                child: Image.network(
                  isCategories ? catData!.image : brand!.image,
                  fit: BoxFit.cover,
                  width: 70.w,
                  height: 70.w,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isCategories ? catData!.name.tr() : brand!.name.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}