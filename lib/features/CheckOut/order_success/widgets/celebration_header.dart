import 'package:e_commerce_full_project/core/widgets/custom_button.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/order_tracking.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CelebrationHeader extends StatelessWidget { 
    final String orderId ; 
    final IconData? icon; 
    final String? headerOrderSuccess; 
    final String? orderMessageSuccess; 
    final String? customButtonText; 
  const CelebrationHeader({ 
    this.icon, 
    this.headerOrderSuccess, 
    this.orderMessageSuccess, 
    this.customButtonText, 
     required this.orderId, 
    super.key ,
     
     });

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                 icon ?? Icons.check_circle,
                  size: 90.sp,
                  color: Colors.green,
                ),
                SizedBox(height: 24.sp),
                Text(
                  headerOrderSuccess ?? 'order_success.title'.tr(),
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Text(
                        orderMessageSuccess ?? 'order_success.message'.tr(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15.h),
                      CustomButton(
                        buttonText: customButtonText ?? 'order_success.track_order'.tr(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderTracking(orderId:orderId),
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
          ],
        ),
     );
  }
}