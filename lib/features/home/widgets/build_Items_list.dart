import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/categories_data.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/category_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/brand_data.dart';
import 'package:e_commerce_full_project/features/home/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildItemsList extends StatefulWidget { 
  final bool isCat ; 
  CategoriesData? catData; 
  BrandData? brandData; 
   BuildItemsList({super.key , required this.isCat , this.brandData , this.catData});

  @override
  State<BuildItemsList> createState() => _BuildItemsListState();
}

class _BuildItemsListState extends State<BuildItemsList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: CustomListView(
        Scroll: Axis.horizontal,
        items:  
         widget.isCat ? 
         widget.catData!.categoriesList 
          :  
          widget.brandData!.brandsList
         ,
        itemBuilder: (context, item, index) { 
          return ListItemWidget( 
             catData: widget.isCat
             ? widget.catData!.categoriesList[index]
             : null,
             brand: widget.isCat
             ? null
             : widget.brandData!.brandsList[index],
             isCategories: widget.isCat,);
        },
      ),
    );
  }
}