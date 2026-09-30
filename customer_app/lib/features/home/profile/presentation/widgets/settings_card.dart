import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final GestureTapCallback? onTap;
  const SettingsCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: colorScheme.onSurface,
                    size: 22.sp,
                  ),
                  child: icon,
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: colorScheme.onSurfaceVariant,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Divider(thickness: 1.0, color: Theme.of(context).iconTheme.color),
        SizedBox(height: 10.h),
      ],
    );
  }
}
