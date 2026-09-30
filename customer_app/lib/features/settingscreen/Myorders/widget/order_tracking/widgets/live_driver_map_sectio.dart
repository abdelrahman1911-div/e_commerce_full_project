import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/order_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/driver_location_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/states/driver_location_states.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/widgets/live_driver_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveDriverMapSection extends StatefulWidget {
  final String orderId;

  const LiveDriverMapSection({
    super.key,
    required this.orderId,
  });

  @override
  State<LiveDriverMapSection> createState() => _LiveDriverMapSectionState();
}

class _LiveDriverMapSectionState extends State<LiveDriverMapSection> {
  String? _watchedDriverId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, List<OrderModel>>(
      builder: (context, orders) {
        OrderModel? selectedOrder;

        try {
          selectedOrder = orders.firstWhere(
            (order) => order.id == widget.orderId,
          );
        } catch (_) {
          selectedOrder = null;
        }

        if (selectedOrder == null) {
          return const SizedBox.shrink();
        }

        final driverId = selectedOrder.driverId;

        if (driverId == null || driverId.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Text(
              'The driver has not been assigned yet.',
            ),
          );
        }

        if (_watchedDriverId != driverId) {
          _watchedDriverId = driverId;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            context.read<DriverLocationCubit>().watchDriverLocation(
                  driverId,
                );
          });
        }

        return BlocBuilder<DriverLocationCubit, DriverLocationState>(
          builder: (context, state) {
            if (state is DriverLocationLoading ||
                state is DriverLocationInitial) {
              return Container(
                height: 280.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is DriverLocationEmpty) {
              return Container(
                height: 280.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: const Center(
                  child: Text(
                    'Driver location is not available yet.',
                  ),
                ),
              );
            }

            if (state is DriverLocationError) {
              return Container(
                height: 280.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(state.message),
                ),
              );
            }

            if (state is DriverLocationSuccess) {
              return LiveDriverMap(
                location: state.location,
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    context.read<DriverLocationCubit>().stopWatching();
    super.dispose();
  }
}