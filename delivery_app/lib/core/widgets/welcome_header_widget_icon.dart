import 'package:e_commerce_delivery_app/core/styling/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeHeaderWidgetIcon extends StatelessWidget {
  final String? svgIcon;
  final String? brandName;
  final String? headTitle;
  final String? subTitle;
  const WelcomeHeaderWidgetIcon({
    this.svgIcon,
    this.brandName,
    this.headTitle,
    this.subTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 15.h),
        Text(
          headTitle ?? "welcome_back".tr(),
          style: AppTextStyles.headline(context),
        ),
        SizedBox(height: 4.h),
        Text(
          subTitle ?? "login_subtitle".tr(),
          style: AppTextStyles.subheadline(context),
        ),
      ],
    );
  }
}
