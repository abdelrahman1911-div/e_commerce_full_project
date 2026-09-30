import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizesWidget extends StatefulWidget {
  final ProductModel prod;

  final ValueChanged<String> onSizeSelected;

  const SizesWidget({
    super.key,
    required this.prod,
    required this.onSizeSelected,
  });

  @override
  State<SizesWidget> createState() => _SizesWidgetState();
}

class _SizesWidgetState extends State<SizesWidget> {
  String? selectedSize;

  @override
  void initState() {
    super.initState();

    // Select the first available size by default.
    for (final item in widget.prod.sizes) {
      if (item.isAvailable) {
        selectedSize = item.label;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onSizeSelected(item.label);
        });

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sizes'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 6.h),

          Row(
            children: widget.prod.sizes.map((item) {
              final String sizeLabel = item.label;

              final bool isAvailable = item.isAvailable;

              final bool isSelected =
                  selectedSize == sizeLabel;

              return GestureDetector(
                onTap: isAvailable
                    ? () {
                        setState(() {
                          selectedSize = sizeLabel;
                        });

                        widget.onSizeSelected(sizeLabel);
                      }
                    : null,
                child: Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 42.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: !isAvailable
                        ? colorScheme.onSurface
                            .withOpacity(0.05)
                        : isSelected
                            ? colorScheme.primary
                            : colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface
                              .withOpacity(0.15),
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
                                  color: colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                              ),
                              Transform.rotate(
                                angle: -0.7,
                                child: Container(
                                  width: 35.w,
                                  height: 1.h,
                                  color: colorScheme.onSurface
                                      .withOpacity(0.15),
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
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
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
