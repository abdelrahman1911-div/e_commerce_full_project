import 'package:e_commerce_full_project/core/errors/widget/user_error_overlay.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OutlinedBUttonnnn extends StatefulWidget {
  final ProductModel prod;

  final Color? scaffoldbackgroundColorAdd;
  final Color? borderColorAdd;
  final String? scaffoldMessageAdd;
  final EdgeInsetsGeometry? padding;
  final String? buttonTextt;

  final bool isBuyNow;

  final IconData? icon;

  final String? selectedColor;
  final String? selectedSize;

  const OutlinedBUttonnnn({
    super.key,
    required this.isBuyNow,
    required this.prod,

    this.buttonTextt,
    this.icon,
    this.padding,
    this.borderColorAdd,
    this.scaffoldMessageAdd,
    this.scaffoldbackgroundColorAdd,

    this.selectedColor,
    this.selectedSize,
  });

  @override
  State<OutlinedBUttonnnn> createState() => _OutlinedBUttonnnnState();
}

class _OutlinedBUttonnnnState extends State<OutlinedBUttonnnn> {
  void _addProductToCart() {
    context.read<CartCubit>().addToCart(
      productId: widget.prod.id,
      selectedColor: widget.selectedColor,
      selectedSize: widget.selectedSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          _addProductToCart();

          if (widget.isBuyNow) {
            context.push(AppRoutes.checkOut);
            return;
          }

          UserErrorOverlay.show(
            context,
            message: 'Added_to_cart'.tr(),
            isSuccess: true,
          );
        },

        style: widget.isBuyNow
            ? ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: widget.padding ?? EdgeInsets.symmetric(vertical: 14.h),
              )
            : OutlinedButton.styleFrom(
                side: BorderSide(
                  color:
                      widget.borderColorAdd ??
                      Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: widget.padding ?? EdgeInsets.symmetric(vertical: 14.h),
              ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon ?? Icons.shopping_bag_outlined,
              color: widget.isBuyNow
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
              size: 18.sp,
            ),

            SizedBox(width: 8.w),

            Text(
              widget.isBuyNow
                  ? (widget.buttonTextt ?? 'buy_now'.tr())
                  : (widget.buttonTextt ?? 'add_to_cart'.tr()),
              style: TextStyle(
                color: widget.isBuyNow
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
