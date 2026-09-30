import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOrLoginWidget extends StatelessWidget {
  const CustomOrLoginWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.dividerTheme.color,
            thickness: theme.dividerTheme.thickness,
            height: theme.dividerTheme.space,
          ),
        ),

        SizedBox(width: 12.w),

        Text(
          'OR SIGN UP WITH',
          style: AppTextStyles.subheadline(context),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Divider(
            color: theme.dividerTheme.color,
            thickness: theme.dividerTheme.thickness,
            height: theme.dividerTheme.space,
          ),
        ),
      ],
    );
  }
}