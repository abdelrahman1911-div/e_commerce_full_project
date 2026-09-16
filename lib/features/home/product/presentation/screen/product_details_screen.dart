import 'package:e_commerce_full_project/core/widgets/app_bar_prod_home.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:e_commerce_full_project/features/home/product/widget/colors_widget.dart';
import 'package:e_commerce_full_project/features/home/product/widget/discription_widget.dart';
import 'package:e_commerce_full_project/features/home/product/widget/outline_button.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/features/home/product/widget/product_widget.dart';
import 'package:e_commerce_full_project/features/home/product/widget/sizes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? selectedColor;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          color: colorScheme.surface,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              OutlinedBUttonnnn(
                prod: widget.product,
                isBuyNow: false,
                selectedColor: selectedColor,
                selectedSize: selectedSize,
              ),

              SizedBox(width: 12.w),

              OutlinedBUttonnnn(
                prod: widget.product,
                isBuyNow: true,
                icon: Icons.monetization_on_outlined,
                selectedColor: selectedColor,
                selectedSize: selectedSize,
              ),
            ],
          ),
        ),

        appBar: AppBarProdHome(
          isHome: false,
          prod: widget.product,
          isProf: false,
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductWidget(pro: widget.product),
                ColorsWidget(
                  product: widget.product,
                  onColorSelected: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),

                SizedBox(height: 4.h),
                SizesWidget(
                  prod: widget.product,
                  onSizeSelected: (size) {
                    setState(() {
                      selectedSize = size;
                    });
                  },
                ),

                SizedBox(height: 16.h),

                DiscriptionWidget(prod: widget.product),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
