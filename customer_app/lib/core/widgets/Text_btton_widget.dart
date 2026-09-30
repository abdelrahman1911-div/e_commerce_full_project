import 'dart:developer';

import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TextBttonWidget extends StatelessWidget {
  final String? mainText;
  final VoidCallback? onTap;
  const TextBttonWidget({this.mainText, this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          log("Forgot password clicked");
          log("Route: ${AppRoutes.changepass}");

          if (onTap != null) {
            onTap!();
          } else {
            context.go(AppRoutes.forgetPass);
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          mainText ?? "forgot_password".tr(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: colorScheme.primary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
