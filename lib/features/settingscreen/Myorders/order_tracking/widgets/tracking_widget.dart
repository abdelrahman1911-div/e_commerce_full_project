import 'package:e_commerce_full_project/features/settingscreen/Myorders/order_tracking/widgets/tracking_step_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingWidget extends StatefulWidget { 
  final double? width; 
  final EdgeInsetsGeometry?  padd; 
  final Color? color ; 
  final BorderRadius? br; 
  final String? headerText; 
  final String? trackingStep1;  
  final String? trackingStep2; 
  final String? trackingStep3; 
  const TrackingWidget({super.key  , this.width , this.padd , this.color , this.br , this.headerText , this.trackingStep1 , this.trackingStep2 , this.trackingStep3});

  @override
  State<TrackingWidget> createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget> {
     late final TextEditingController addressController;
  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: "Atletico Madrid znzana 7");
  }
  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) { 
    final theme = Theme.of(context);  
    final isDark = theme.brightness == Brightness.dark;

    return Container(
                    width: widget.width??double.infinity,
                    padding: widget.padd ??  EdgeInsets.all(16.w),  
                    decoration: BoxDecoration(
                      color: widget.color ?? (isDark ? Colors.grey[900] : Colors.white),
                      borderRadius: widget.br ?? BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                               widget.headerText ??  
                               "order_tracking.deliver_to".tr(),
                              style: theme.textTheme.titleMedium,
                            ),
                            SizedBox(width: 95.h),
                            Expanded(
                              child: Text(
                                addressController.text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        TrackingStep(
                          title: widget.trackingStep1 ?? 'order_tracking.package_shipped'.tr(),
                          isActive: true,
                          isLast: false,
                        ),
                        TrackingStep(
                          title: widget.trackingStep2 ??  'order_tracking.in_transit'.tr(),
                          isActive: false,
                          isLast: false,
                        ),
                        TrackingStep(
                          title: widget.trackingStep3 ?? 'order_tracking.arriving_today'.tr(),
                          isActive: false,
                          isLast: true,
                        ),
                      ],
                    ),
                  );
                  }
                }