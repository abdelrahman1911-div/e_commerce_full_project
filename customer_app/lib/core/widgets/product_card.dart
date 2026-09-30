import 'dart:developer';

import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/home/favourite/peresentation/cubit/favourite_cubit.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProductCardWidget extends StatefulWidget {
  final ProductModel product;

  // Brand name coming from Firebase
  final String? brandName;

  const ProductCardWidget({super.key, required this.product, this.brandName});

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            context.push(AppRoutes.product, extra: widget.product);
          },
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            children: [
              Container(
                height: 140.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(widget.product.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // =========================
              // Favorite
              // =========================
              Positioned(
                top: 8.h,
                right: 8.w,
                child: BlocBuilder<FavouriteCubit, FavouriteState>(
                  builder: (context, state) {
                    final favouriteCubit = context.read<FavouriteCubit>();

                    final isFav = favouriteCubit.isFavourite(widget.product);

                    return Material(
                      color: colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20.r),
                      child: InkWell(
                        onTap: () async {
                          final favouriteCubit = context.read<FavouriteCubit>();

                          final isAlreadyFavourite = favouriteCubit.isFavourite(
                            widget.product,
                          );

                          await favouriteCubit.toggleFavourite(widget.product);

                          if (!isAlreadyFavourite && context.mounted) {
                            showFavoriteMessage(context);
                          }
                        },
                        borderRadius: BorderRadius.circular(20.r),
                        child: Padding(
                          padding: EdgeInsets.all(7.w),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_outline,
                            color: isFav
                                ? colorScheme.error
                                : colorScheme.onSurfaceVariant,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 5.h),
        Text(
          widget.product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall!.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),

        Row(
          children: [
            Expanded(
              child: Text(
                widget.brandName ?? widget.product.brandId,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            SizedBox(width: 4.w),

            Icon(Icons.star, color: Colors.amber, size: 14.sp),

            SizedBox(width: 2.w),

            Text(
              widget.product.rating.toString(),
              style: theme.textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurface,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(width: 2.w),

            Text(
              '(${widget.product.reviews})',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        // =========================
        // Price + Discount + Cart
        // =========================
        Row(
          children: [
            Text(
              widget.product.currentPrice.toString(),
              style: theme.textTheme.bodyLarge!.copyWith(
                color: colorScheme.error,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(width: 4.w),

            Text(
              widget.product.oldPrice.toString(),
              style: theme.textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.lineThrough,
                decorationColor: colorScheme.onSurfaceVariant,
              ),
            ),

            const Spacer(),

            // =========================
            // Discount
            // =========================
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                widget.product.discount,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: colorScheme.error,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(width: 6.w),

            // =========================
            // Add To Cart
            // =========================
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green.shade500,
                    content: Text('Please_choose_size_color'.tr()),
                    duration: const Duration(milliseconds: 1500),
                  ),
                );

                context.push(AppRoutes.product, extra: widget.product);
              },
              borderRadius: BorderRadius.circular(6.r),
              child: Container(
                width: 25.w,
                height: 20.h,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: colorScheme.onPrimary,
                  size: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================
  // FAVORITE MESSAGE
  // ===========================================================

  void showFavoriteMessage(BuildContext context) {
    final overlay = Overlay.of(context);

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 70.h,
          left: 20.w,
          right: 20.w,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite, color: Colors.red, size: 20.sp),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Added to Favorites',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 2.h),

                        Text(
                          widget.product.name,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 1), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }
}
