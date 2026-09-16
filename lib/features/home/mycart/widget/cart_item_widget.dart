import 'package:e_commerce_full_project/core/styling/appcolors.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel carti;

  const CartItemWidget({super.key, required this.carti});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark
        ? AppColors.darkPrimaryButton
        : AppColors.lightPrimaryButton;

    final quantity = carti.quantity;

    return Container(
      height: 120.h,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade400, width: 1.w),
      ),
      child: Row(
        children: [
          // =====================================================
          // IMAGE
          // =====================================================
          Container(
            width: 75.w,
            height: 75.h,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkInputFill
                  : AppColors.lightInputFill,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                carti.product.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // =====================================================
          // PRODUCT INFO
          // =====================================================
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =================================================
                // NAME + DELETE
                // =================================================
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        carti.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5.h),

                // =================================================
                // PRICE
                // =================================================
                Text(
                  carti.product.currentPrice.toString(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // =================================================
                // COLOR
                // =================================================
                if (carti.selectedColor != null &&
                    carti.selectedColor!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Text(
                      'Color: ${carti.selectedColor}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                // =================================================
                // SIZE
                // =================================================
                if (carti.selectedSize != null &&
                    carti.selectedSize!.isNotEmpty)
                  Text(
                    'Size: ${carti.selectedSize}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 0.w),

          // =====================================================
          // QUANTITY
          // =====================================================
          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // DELETE
              InkWell(
                onTap: () {
                  context.read<CartCubit>().removeFromCart(carti.cartItemId);
                },

                child: Icon(
                  Icons.delete_outline_rounded,

                  size: 18.sp,

                  color: AppColors.accentYellow,
                ),
              ),

              SizedBox(height: 8.h),

              // QUANTITY
              Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  // MINUS
                  InkWell(
                    onTap: () {
                      context.read<CartCubit>().decreaseQuantity(
                        carti.cartItemId,
                      );
                    },

                    child: Icon(
                      Icons.remove,

                      size: 15.sp,

                      color: quantity > 1
                          ? theme.colorScheme.onSurface
                          : Colors.grey,
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // NUMBER
                  Text(
                    '$quantity',

                    style: TextStyle(
                      fontSize: 12.sp,

                      fontWeight: FontWeight.bold,

                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // PLUS
                  InkWell(
                    onTap: () {
                      context.read<CartCubit>().increaseQuantity(
                        carti.cartItemId,
                      );
                    },

                    child: Icon(
                      Icons.add,

                      size: 15.sp,

                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
