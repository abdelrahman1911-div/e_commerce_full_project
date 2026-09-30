import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String iconPath;

  const CustomIconButton({super.key, this.onTap, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xffE8ECF4), width: 1),
        ),
        child: Center(
          child: SvgPicture.asset(iconPath, width: 24.w, height: 24.h),
        ),
      ),
    );
  }
}
