import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DeliveryWidget extends StatefulWidget {
  final GestureTapCallback fedexClick;
  final GestureTapCallback dhlClick; 
  final String deliveryway; 
  const DeliveryWidget({
    super.key,
    required this.fedexClick, 
    required this.deliveryway, 
    required this.dhlClick,
  });

  @override
  State<DeliveryWidget> createState() => _DeliveryWidgetState();
}

class _DeliveryWidgetState extends State<DeliveryWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedBorderColor = isDark ? Colors.white : Colors.black;
    final unselectedBorderColor = isDark
        ? Colors.grey.shade700
        : Colors.grey.shade300;
    final cardColor = isDark ? theme.cardColor : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('delivery_methods'.tr(), style: theme.textTheme.titleMedium),

        SizedBox(height: 10.h),

        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10.r),

              onTap: widget.fedexClick,

              child: Container(
                height: 50.h,
                width: 120.w,

                decoration: BoxDecoration(
                  color: cardColor,

                  borderRadius: BorderRadius.circular(10.r),

                  border: Border.all(
                    width:widget.deliveryway == "fedex" ? 2 : 1,

                    color:widget.deliveryway == "fedex"
                        ? selectedBorderColor
                        : unselectedBorderColor,
                  ),
                ),

                alignment: Alignment.center,

                child: SvgPicture.asset("assets/fedex.svg"),
              ),
            ),

            SizedBox(width: 30.w),

            InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: widget.dhlClick,
              child: Container(
                height: 50.h,
                width: 120.w,

                decoration: BoxDecoration(
                  color: cardColor,

                  borderRadius: BorderRadius.circular(10.r),

                  border: Border.all(
                    width: widget.deliveryway == "dhl" ? 2 : 1,

                    color: widget.deliveryway == "dhl"
                        ? selectedBorderColor
                        : unselectedBorderColor,
                  ),
                ),

                alignment: Alignment.center,

                child: SvgPicture.asset("assets/dhl.svg"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
