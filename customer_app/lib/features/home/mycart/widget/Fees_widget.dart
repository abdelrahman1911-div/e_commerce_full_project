import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/styling/appcolors.dart';
import 'package:e_commerce_full_project/core/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FeesWidget extends StatelessWidget {
  final String? firstWord;
  final String? firstValue;
  final String? secondWord;
  final String? secondValue;
  final String? thirdWord;
  final String? thirdValue;
  final String? buttonText;
  final String? fourWord; 
  final String? fourValue; 
  final String? fiveWord; 
  final String? fiveValue;  
  final bool isCheckOut;  
  final VoidCallback? onPressed; 
  const FeesWidget({ 
   required this.isCheckOut, 
    this.firstWord,
    this.firstValue,
    this.secondWord,
    this.secondValue,
    this.thirdWord,
    this.thirdValue,
    this.buttonText, 
    this.fourWord, 
    this.fourValue, 
    this.fiveWord, 
    this.fiveValue,  
    this.onPressed, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark
        ? AppColors.darkPrimaryButton
        : AppColors.lightPrimaryButton;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                firstWord ?? 'total'.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                firstValue ?? "",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    secondWord ?? 'delivery_fees'.tr(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.delivery_dining_outlined, color: primaryColor),
                ],
              ),

              Text(
                secondValue ?? "",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // =================================
          // SUBTOTAL
          // =================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                thirdWord ?? 'subtotal'.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                thirdValue ?? "",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),  
           SizedBox(height: 10.h),

          // =================================
          // SUBTOTAL
          // =================================
        isCheckOut?  
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fourWord ?? 'delivered_by'.tr(), 
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    fourValue ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ), 
              SizedBox(height: 10.h),
              
              // =================================
              // SUBTOTAL
              // =================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fiveWord ?? 'payment_method'.tr(), 
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    fiveValue ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ) : SizedBox.shrink(), 

          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: CustomButton(
              buttonText: buttonText ?? 'check_out_button'.tr(),
              icon: Icon(
                Icons.monetization_on_outlined,
                color: isDark ? Colors.black : Colors.white,
              ),
              onPressed: 
               onPressed ?? 
               () {
                context.push(AppRoutes.checkOut);
              },
            ),
          ),
        ],
      ),
    );
  }
}
