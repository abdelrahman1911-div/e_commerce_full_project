import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/styling/appcolors.dart';
import 'package:e_commerce_full_project/features/home/favourite/peresentation/cubit/favourite_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_cubit.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductWidget extends StatefulWidget {
  final ProductModel pro;
  final String? img;

  const ProductWidget({super.key, required this.pro, this.img});
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    widget.img ?? widget.pro.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.pro.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),

                BlocBuilder<FavouriteCubit, FavouriteState>(
                  builder: (context, state) {
                    final isFavorite = context
                        .read<FavouriteCubit>()
                        .isFavourite(widget.pro);

                    return InkWell(
                      onTap: () {
                        final favouriteCubit = context.read<FavouriteCubit>();

                        final isAlreadyFavourite = favouriteCubit.isFavourite(
                          widget.pro,
                        );

                        favouriteCubit.toggleFavourite(widget.pro);

                        if (!isAlreadyFavourite) {
                          showFavoriteMessage(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(20.r),
                      child: Padding(
                        padding: EdgeInsets.all(2.r),
                        child: isFavorite
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : Icon(
                                Icons.favorite_outline,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 3.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<BrandCubit, BrandState>(
                  builder: (context, brandState) {
                    String brandName = widget.pro.brandId;

                    if (brandState is BrandSuccess) {
                      final matchingBrands = brandState.brands.where(
                        (brand) => brand.id == widget.pro.brandId,
                      );

                      if (matchingBrands.isNotEmpty) {
                        brandName = matchingBrands.first.name;
                      }
                    }

                    return Text(
                      brandName,
                      style: AppTextStyles.subheadline(context),
                    );
                  },
                ),

                const Spacer(),

                Icon(Icons.star, color: Colors.amberAccent, size: 17.sp),

                SizedBox(width: 2.w),

                Text(
                  '${widget.pro.rating}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(width: 3.w),
                Text(
                  '${widget.pro.reviews}',
                  style: AppTextStyles.buttonText(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pro.currentPrice.toString(),
                  style: AppTextStyles.subheadline(context).copyWith(
                    color: AppColors.priceRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  widget.pro.oldPrice.toString(),
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                    decoration: TextDecoration.lineThrough,
                    fontSize: 15.sp,
                  ),
                ),

                SizedBox(width: 4.w),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.priceRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.pro.discount,
                    style: TextStyle(
                      color: AppColors.priceRed,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
                          widget.pro.name,
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
