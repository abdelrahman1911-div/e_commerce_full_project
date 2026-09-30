import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorsWidget extends StatefulWidget {
  final ProductModel product;

  final ValueChanged<String> onColorSelected;

  const ColorsWidget({
    super.key,
    required this.product,
    required this.onColorSelected,
  });

  @override
  State<ColorsWidget> createState() => _ColorsWidgetState();
}

class _ColorsWidgetState extends State<ColorsWidget> {
  int selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();

    // Send the default selected color to the parent.
    if (widget.product.colors.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onColorSelected(
          widget.product.colors.first.name,
        );
      });
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
            ' ${'color'.tr()} : '
            '${widget.product.colors.map((color) => color.name).join(', ')}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 4.h),

          Row(
            children: List.generate(
              widget.product.colors.length,
              (index) {
                final bool isSelected =
                    selectedColorIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorIndex = index;
                    });

                    widget.onColorSelected(
                      widget.product.colors[index].name,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.all(3.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: 1.w,
                      ),
                    ),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: widget
                            .product
                            .colors[index]
                            .colorValue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.onSurface
                              .withOpacity(0.12),
                          width: 0.5.w,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
