import 'package:e_commerce_full_project/core/widgets/custom_icon_button.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomSocialLoginIcons extends StatelessWidget {
  const CustomSocialLoginIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.w),
        CustomIconButton(
          onTap: () {
            context.read<AuthCubit>().loginWithFacebook();
          },
          iconPath: "assets/facebook.svg",
        ),
        SizedBox(width: 8.w),
        CustomIconButton(
          onTap: () {
            context.read<AuthCubit>().loginWithGoogle();
          },
          iconPath: "assets/google.svg",
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
