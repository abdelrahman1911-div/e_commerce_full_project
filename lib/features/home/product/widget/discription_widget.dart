import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscriptionWidget extends StatelessWidget {
  final ProductModel prod ; 
  const DiscriptionWidget({super.key , required this.prod});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
             prod.description, 
            style: AppTextStyles.subheadline(context).copyWith(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w400,
            ),
          ),
        ] 
     ), 
    );
  }
}