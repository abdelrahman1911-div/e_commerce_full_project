import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizesWidget extends StatefulWidget {
  final ProductModel prod;
  const SizesWidget({super.key, required this.prod});

  @override
  State<SizesWidget> createState() => _SizesWidgetState();
}

class _SizesWidgetState extends State<SizesWidget> {
  String selectedSize = 'L';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sizes'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 6.h),
          Row(
            children: widget.prod.sizes.map((item) {
              final String sizeLabel = item.label;
              final bool isAvailable = item.isAvailable;
              final bool isSelected = selectedSize == sizeLabel;
              return GestureDetector(
                onTap: isAvailable
                    ? () {
                        setState(() {
                          selectedSize = sizeLabel;
                        });
                      }
                    : null,
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 42.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: !isAvailable
                        ? Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.05)
                        : isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.15),
                    ),
                  ),
                  child: Center(
                    child: !isAvailable
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                sizeLabel,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.3),
                                ),
                              ),
                              Transform.rotate(
                                angle: -0.7,
                                child: Container(
                                  width: 35.w,
                                  height: 1.h,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.15),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            sizeLabel,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
