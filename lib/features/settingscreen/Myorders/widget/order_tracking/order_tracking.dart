import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/widgets/order_details_widget.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/widgets/tracking_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTracking extends StatefulWidget {
  final String orderId;
  const OrderTracking({super.key, required this.orderId});
  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: isDark ? Colors.black54 : Colors.grey[100],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    "order_tracking.title".tr(),
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 10.h),
                  OrderDetailsWidget(orderid: widget.orderId),
                  SizedBox(height: 20.h),
                  TrackingWidget(orderid: widget.orderId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
