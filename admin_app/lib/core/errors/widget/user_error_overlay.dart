import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserErrorOverlay extends StatelessWidget {
  final String message;
  final bool isSuccess;
  final VoidCallback? onPressed;
final bool barrierDismissible;
  const UserErrorOverlay({
    super.key,
    required this.message,
    required this.isSuccess,
    this.onPressed, 
      this.barrierDismissible = true,

  });

  static Future<void> show(
    BuildContext context, {
    required String message,
    required bool isSuccess,
    VoidCallback? onPressed, 
      bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible, 
      barrierColor: Colors.black54,
      builder: (_) {
        return UserErrorOverlay(
          message: message,
          isSuccess: isSuccess,
          onPressed: onPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color mainColor = isSuccess
        ? Colors.green
        : Colors.red;

    final IconData icon = isSuccess
        ? Icons.check_rounded
        : Icons.close_rounded;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 35.w),
      child: Container(
        width: 300.w,
        padding: EdgeInsets.symmetric(
          horizontal: 22.w,
          vertical: 28.h,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // =========================
            // Success / Error Icon
            // =========================

            Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainColor.withOpacity(0.10),
              ),
              child: Icon(
                icon,
                color: mainColor,
                size: 55.sp,
              ),
            ),

            SizedBox(height: 20.h),

            // =========================
            // Message
            // =========================

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: theme.colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 24.h),

            // =========================
            // OK Button
            // =========================

            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressed?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
