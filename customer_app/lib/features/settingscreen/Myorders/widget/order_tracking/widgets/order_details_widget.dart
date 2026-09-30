import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/order_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/widgets/order_product_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsWidget extends StatelessWidget { 
  final String orderid ; 
  const OrderDetailsWidget({super.key , required this.orderid});
         
  @override
  Widget build(BuildContext context) { 
        final theme = Theme.of(context);
    final date = DateFormat('d MMMM yyyy').format(DateTime.now());
    final isDark = theme.brightness == Brightness.dark;
    return                   BlocBuilder<OrderCubit, List<OrderModel>>(
                    builder: (context, orders) {
                      OrderModel? selectedOrder;
                      try {
                        selectedOrder = orders.firstWhere(
                          (order) => order.id == orderid,
                        );
                      } catch (_) {
                        selectedOrder = null;
                      }
                      if (selectedOrder == null) {
                        return const Center(child: Text('Order not found'));
                      }
                      final products = selectedOrder.products;
                      const double delivery = 45.0;
                      double subtotal = 0;
                      for (final product in products) {
                        final double price =
                            double.tryParse(
                              product.product.currentPrice.toString().replaceAll(
                                '\$',
                                '',
                              ),
                            ) ??
                            0;
                        final int quantity = product.quantity;
                        subtotal += price * quantity;
                      }
                      final double total = subtotal + delivery;
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[900] : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "order_tracking.order_id".tr(),
                                  style: theme.textTheme.labelMedium,
                                ),
                                Text(
                                  selectedOrder.id,
                                  style: theme.textTheme.labelMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "order_tracking.due_date".tr(),
                                  style: theme.textTheme.labelMedium,
                                ),
                                Text(date, style: theme.textTheme.labelMedium),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Divider(color: Colors.grey.withValues(alpha: 0.3)),
                            SizedBox(height: 5.h),
                            CustomListView(
                              shrinkWrap: true,
                              Scroll: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              items: products,
                              itemBuilder: (context, item, index) {
                                item = products[index];
                                return OrderProductItem(product: item);
                              },
                            ),
                            SizedBox(height: 8.h),
                            // =========================================
                            // TOTAL
                            // =========================================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "order_tracking.total".tr(),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${total.toStringAsFixed(2)}',

                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Divider(color: Colors.grey.withValues(alpha: 0.3)),
                            SizedBox(height: 4.h),
                            // =========================================
                            // CANCEL ORDER
                            // =========================================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return AlertDialog(
                                          title: Text(
                                            'order_tracking.cancel_order_title'
                                                .tr(),
                                          ),
                                          content: Text(
                                            'order_tracking.cancel_order_message'
                                                .tr(),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(dialogContext);
                                              },
                                              child: Text(
                                                'order_tracking.cancel'.tr(),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<OrderCubit>()
                                                    .removeOrder(
                                                      orderid,
                                                    );
                                                Navigator.pop(dialogContext);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'order_tracking.yes'.tr(),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "order_tracking.cancel_order".tr(),

                                    style: theme.textTheme.labelMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,

                                          color: theme.colorScheme.error,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.sp,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ); 
  }
}