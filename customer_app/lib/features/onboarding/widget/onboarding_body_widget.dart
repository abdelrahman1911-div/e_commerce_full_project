import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingBodyWidget extends StatelessWidget { 

  final SvgPicture? mainOnBoardingSvg; 

  final  String? headerText; 
 
  final  String? subHeaderText; 
 
  const OnboardingBodyWidget({super.key , this.mainOnBoardingSvg, this.headerText , this.subHeaderText});
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100.h),
        Container(
          height: 250.h,
          width: 300.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child:  mainOnBoardingSvg ?? SvgPicture.asset("assets/Delivery.svg"),
        ),
        SizedBox(height: 20.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerText ?? "Lets Get Started",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: AppTextStyles.headline(context).fontSize,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
             subHeaderText ??"Our goal is to ensure that you have everything you need to feel comfortable, confident, and ready to make an impact.",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: AppTextStyles.fieldLabel(context).fontSize,
              ),
            ),
            SizedBox(height: 20.h),
          ],
      )
      ]
      );
  } 
}