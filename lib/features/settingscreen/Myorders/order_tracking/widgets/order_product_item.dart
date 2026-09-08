import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderProductItem extends StatelessWidget {
  final ProductModel product;
  const OrderProductItem({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quantity = product.quantity;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 55.w,
            height: 55.h,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Image.network(product.image, fit: BoxFit.cover),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text('x$quantity', style: theme.textTheme.bodySmall),
          SizedBox(width: 12.w),
          Text(
            product.currentPrice.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
