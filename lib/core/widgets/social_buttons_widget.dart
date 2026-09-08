import 'package:e_commerce_full_project/core/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSocialLoginIcons extends StatelessWidget {
  const CustomSocialLoginIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return  
        Row(
          children: [
            CustomIconButton( onTap: () {},
               iconPath: "assets/facebook.svg",
               ),
           SizedBox(width: 8.w),
         CustomIconButton( 
          onTap: () {},
          iconPath: "assets/google.svg",
        ),
        SizedBox(width: 8.w),
         CustomIconButton( onTap: () {},
          iconPath: "assets/apple.svg",
        ),
       ],
      );    
  }
}