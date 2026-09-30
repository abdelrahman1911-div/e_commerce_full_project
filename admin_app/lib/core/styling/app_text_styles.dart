import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle get whiteB => TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.26,
  );

  static TextStyle   headline (BuildContext context) => 
      Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontSize: 26.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.26,
    );  

  static TextStyle brandWord(BuildContext context) =>
     Theme.of(context).textTheme.titleSmall!.copyWith(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.15,
    );
    static TextStyle Title (BuildContext context) => 
     Theme.of(context).textTheme.titleMedium!.copyWith(
       fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
     ); 
  static TextStyle subheadline(BuildContext context) => 
     Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: 13.5.sp,
      fontWeight: FontWeight.w400,
      height: 1.4,
    );

  static TextStyle fieldLabel(BuildContext context) =>
     Theme.of(context).textTheme.labelLarge!.copyWith(
      fontSize: 12.5.sp,
      fontWeight: FontWeight.w500,
    );

  // ============================================================
  // Button Text
  // ============================================================
  static TextStyle buttonText(BuildContext context) =>
   Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 14.5.sp,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onPrimary,
    );

  // ============================================================
  // Body Text
  // ============================================================
  static TextStyle body(BuildContext context) =>
   Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    );

  // ============================================================
  // Small Text
  // ============================================================
  static TextStyle small(BuildContext context) =>
   Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
    );

  static TextStyle title(BuildContext context) =>
     Theme.of(context).textTheme.titleSmall!.copyWith(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
    );
  }
