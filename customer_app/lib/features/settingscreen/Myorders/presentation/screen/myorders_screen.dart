import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('my_orders.title'.tr())),
      body: BlocBuilder<OrderCubit, List<OrderModel>>(
        builder: (context, orders) {
          if (orders.isEmpty) {
            return NoItemsWidget();
          }
          return CustomListView(
            separatorBuilder: (context, index) {
              return SizedBox(height: 12.h);
            },
            items: orders,
            itemBuilder: (context, item, index) {
              return OrderCard(order: orders[index]);
            },
            Scroll: Axis.vertical,
          );
        },
      ),
    );
  }
}
