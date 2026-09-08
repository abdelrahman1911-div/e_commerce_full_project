import 'package:e_commerce_full_project/features/Categoriesscreen/data/categories_data.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/category_model.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/categorise_screen.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/brand_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListItemWidget extends StatelessWidget { 
  BrandModel? brand ;  
  final bool isCategories;  
  CategoryModel? catData; 
  ListItemWidget({super.key ,this.catData  , this.brand , required this.isCategories  });

  @override
  Widget build(BuildContext context) { 
    final colorscheme = Theme.of(context).colorScheme; 
    return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if(isCategories == true) {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoriseScreen(
                          selectedCategoryName: catData!.name,
                        ),
                      ),
                    );
                    } 
                    else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BrandScreen(selectedCategoryName: brand!.name),
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
                       isCategories ?  
                       catData!.image 
                      : 
                        brand!.image,
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
                 isCategories ? 
                 catData!.name.tr()
                 : 
                  brand!.name.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: colorscheme.primary,
                  ),
                ),
              ],
            ),
          );
  }
}