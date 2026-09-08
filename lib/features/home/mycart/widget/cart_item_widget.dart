import 'package:e_commerce_full_project/core/styling/appcolors.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatelessWidget {
  final ProductModel product;

  const CartItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark
        ? AppColors.darkPrimaryButton
        : AppColors.lightPrimaryButton;

    final quantity = product.quantity;

    return Container(
      height: 95,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade400, width: 1.w),
      ),
      child: Row(
        children: [
          // IMAGE
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkInputFill
                  : AppColors.lightInputFill,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                product.image,
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

          const SizedBox(width: 12),

          // PRODUCT INFO
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  product.currentPrice,
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // RIGHT SIDE
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    context.read<CartCubit>().removeFromCart(product);
                  },
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 17,
                    color: AppColors.accentYellow,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // QUANTITY
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: quantity > 1
                        ? () {
                            context.read<CartCubit>().decreaseQuantity(product);
                          }
                        : null,
                    child: Icon(
                      Icons.remove,
                      size: 15,
                      color: quantity > 1 ? null : Colors.grey,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 10),

                  InkWell(
                    onTap: () {
                      context.read<CartCubit>().increaseQuantity(product);
                    },
                    child: const Icon(Icons.add, size: 15),
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
