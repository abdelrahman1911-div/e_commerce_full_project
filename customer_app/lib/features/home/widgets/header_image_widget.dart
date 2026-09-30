import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/features/All_categories_brands/all_categorise_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderImageWidget extends StatefulWidget {
  String? image;
  double? counterWidth;
  double? counterHeight;
  Color? counterColor;
  DateTime? endTime;
  double? posWidthOfshopNow;
  double? posHeightOfShopNow;
  String? shopNowText;
  String? finishText;
  IconData? iconNextToShopNow;
  HeaderImageWidget({
    this.image,
    this.counterWidth,
    this.counterHeight,
    this.counterColor,
    this.endTime,
    this.posWidthOfshopNow,
    this.posHeightOfShopNow,
    this.shopNowText,
    this.iconNextToShopNow,
    super.key,
  });

  @override
  State<HeaderImageWidget> createState() => _HeaderImageWidgetState();
}

class _HeaderImageWidgetState extends State<HeaderImageWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Image.asset(
          widget.image ?? "assets/Homescreen.jpg",
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Positioned(
          top: 30.h,
          left: 10.w,
          child: Container(
            width: widget.counterWidth ?? 130.w,
            height: widget.counterHeight ?? 25.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: widget.counterColor ?? Colors.white,
            ),
            child: CountdownTimer(
              endTime:
                  (widget.endTime ??
                          DateTime.now().add(const Duration(days: 2)))
                      .millisecondsSinceEpoch,
              widgetBuilder: (_, time) {
                if (time == null) {
                  return Text(
                    widget.finishText ?? 'finished'.tr(),
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  );
                }
                final hours = time.hours?.toString().padLeft(2, '0') ?? '00';
                final minutes = time.min?.toString().padLeft(2, '0') ?? '00';
                final seconds = time.sec?.toString().padLeft(2, '0') ?? '00';
                final days = time.days ?? 0;

                String formattedTime;
                if (days > 0) {
                  formattedTime =
                      '${days}d : ${hours}h : ${minutes}m : ${seconds}s';
                } else {
                  formattedTime = '${hours}h : ${minutes}m : ${seconds}s';
                }
                return Center(
                  child: Text(
                    formattedTime,
                    style: AppTextStyles.subheadline(
                      context,
                    ).copyWith(color: colorScheme.onSecondary, fontSize: 9.sp),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          right: widget.posWidthOfshopNow ?? 8.w,
          bottom: widget.posHeightOfShopNow ?? 2.h,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCategoriesScreen()),
              );
            },
            child: Row(
              children: [
                Text(
                  widget.shopNowText ?? 'shop_now'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    color: colorScheme.onSecondary,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  widget.iconNextToShopNow ?? Icons.arrow_forward_ios,
                  size: 10.sp,
                  color: colorScheme.onSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
