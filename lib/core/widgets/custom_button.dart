import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Icon? icon;
  final VoidCallback? onPressed;
  const CustomButton({
    required this.buttonText,
    this.icon,
    this.onPressed,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ElevatedButton(
        onPressed : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(buttonText, style: AppTextStyles.buttonText(context)),
            if (icon != null) ...[
              SizedBox(width: 8.w),
              IconTheme(
                data: IconThemeData(
                  color: theme.colorScheme.onPrimary,
                  size: 18.sp,
                ),
                child: icon!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
