import 'package:e_commerce_full_project/features/Categoriesscreen/data/categories_data.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/category_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/brand_data.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/brand_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandCategoriesWidget extends StatefulWidget { 
 final  BrandModel? brandModel;
  final bool isCategories; 
  final CategoryModel? categoryModel;   
  final bool isSelected; 
  final VoidCallback onTap; 
const  BrandCategoriesWidget({
    super.key,
     this.brandModel,
    required this.isSelected, 
    required this.isCategories,  
    required this.onTap, 
    this.categoryModel
  });
  @override
  State<BrandCategoriesWidget> createState() => _BrandCategoriesWidgetState();
}

class _BrandCategoriesWidgetState extends State<BrandCategoriesWidget> {
  late String selectedBrand;
  String? selectedCategoryName;
  final BrandData cat = BrandData(); 
  final CategoriesData categories = CategoriesData(); 
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector( 
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.all(widget.isSelected ? 3.r : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isSelected
                      ? colorScheme.primary
                      : Colors.transparent,
                  width: 2.w,
                ),
              ),
              child: Container(
                width: 65.w,
                height: 65.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: ClipOval(
                  child: Image.network( 
                    widget.isCategories ? widget.categoryModel!.image :  
                    widget.brandModel!.image,
                    fit: BoxFit.cover,
                    width: 65.w,
                    height: 65.w,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text( 
            widget.isCategories ? widget.categoryModel!.name.tr() : 
            widget.brandModel!.name.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
              color: widget.isSelected ? colorScheme.primary : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
