import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OutlinedBUttonnnn extends StatefulWidget {
  final ProductModel prod;
  Color? scaffoldbackgroundColorAdd;
  Color? borderColorAdd;
  String? scaffoldMessageAdd;
  EdgeInsetsGeometry? padding;
  String? buttonTextt;
  bool isBuyNow;
  IconData? icon;
  OutlinedBUttonnnn({
    super.key,
    required this.isBuyNow,
    this.buttonTextt,
    this.icon,
    this.padding,
    this.borderColorAdd,
    required this.prod,
    this.scaffoldMessageAdd,
    this.scaffoldbackgroundColorAdd,
  });

  @override
  State<OutlinedBUttonnnn> createState() => _OutlinedBUttonnnnState();
}

class _OutlinedBUttonnnnState extends State<OutlinedBUttonnnn> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          if (widget.isBuyNow == true) {
            context.read<CartCubit>().addToCart(widget.prod);
            context.push(AppRoutes.checkOut);
          } else {
            context.read<CartCubit>().addToCart(widget.prod);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor:
                    widget.scaffoldbackgroundColorAdd ?? Colors.green.shade400,
                content: Text(
                  widget.scaffoldMessageAdd ?? 'Added_to_cart',
                ).tr(),
                duration: const Duration(milliseconds: 500),
              ),
            );
          }
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
              color: widget.isBuyNow == true
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              widget.isBuyNow == true
                  ? (widget.buttonTextt ?? 'buy_now'.tr())
                  : (widget.buttonTextt ?? 'add_to_cart'.tr()),
              style: TextStyle(
                color: widget.isBuyNow == true
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
