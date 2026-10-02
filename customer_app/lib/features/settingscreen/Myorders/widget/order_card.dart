import 'package:e_commerce_full_project/core/errors/widget/user_error_overlay.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/order_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/order_tracking.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // =========================
    // ORDER DATA
    // =========================

    final String orderId = order.id.toString();

    final String status = order.status;

    final String address = order.address;

    final String paymentMethod = order.paymentMethod;

    final double totalPrice = order.totalPrice;

    final products = order.products;

    final DateTime orderDate = order.date;

    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(orderDate);

    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderTracking(orderId: order.id)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.onSurface.withOpacity(.15)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${'my_orders.order'.tr()} #$orderId',

                      style: TextStyle(
                        color: colorScheme.onSurface,

                        fontWeight: FontWeight.bold,

                        fontSize: 15,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                formattedDate,
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(.5),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                '${products.length} ${'my_orders.items'.tr()}',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      address,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(.7),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Divider(color: colorScheme.onSurface.withOpacity(.15)),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'my_orders.total'.tr(),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // =========================
              // PAYMENT METHOD
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'my_orders.payment_method'.tr(),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    paymentMethod.toUpperCase(),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // =========================
              // CANCEL BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 44,

                child: OutlinedButton(
                  onPressed: () {
                    _showCancelDialog(context);
                  },

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: Text(
                    'my_orders.cancel_order'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('my_orders.cancel_order_title'.tr()),
          content: Text('my_orders.cancel_order_message'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                context.read<OrderCubit>().removeOrder(order.id);
                Navigator.pop(dialogContext);
                UserErrorOverlay.show(
                  context,
                  message: 'my_orders.cancelled_successfully'.tr(),
                  isSuccess: true,
                );
              },
              child: Text(
                'my_orders.yes_cancel'.tr(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('my_orders.no'.tr()),
            ),
          ],
        );
      },
    );
  }
}
