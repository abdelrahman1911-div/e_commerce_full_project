import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/route_model.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/driver_location_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/order_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/routing_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/states/driver_location_states.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/states/routing_states.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/widgets/live_driver_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

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
  LatLng? _lastRoutedDriverLocation;
  LatLng? _lastRoutedDestination;

  static const double _routeRefreshDistanceInMeters = 100;

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
          return const _InfoCard(
            child: Text(
              'The driver has not been assigned yet.',
            ),
          );
        }

        if (_watchedDriverId != driverId) {
          _watchedDriverId = driverId;
          _lastRoutedDriverLocation = null;
          _lastRoutedDestination = null;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            context.read<RoutingCubit>().reset();

            context
                .read<DriverLocationCubit>()
                .watchDriverLocation(driverId);
          });
        }

        final destinationLatitude = selectedOrder.destinationLatitude;
        final destinationLongitude = selectedOrder.destinationLongitude;

        final hasDestination =
            destinationLatitude != null && destinationLongitude != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DriverInfo(
              driverId: driverId,
            ),
            SizedBox(height: 16.h),
            BlocBuilder<DriverLocationCubit, DriverLocationState>(
              builder: (context, driverState) {
                if (driverState is DriverLocationLoading ||
                    driverState is DriverLocationInitial) {
                  return const _MapContainer(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (driverState is DriverLocationEmpty) {
                  return const _MapContainer(
                    child: Center(
                      child: Text(
                        'Driver location is not available yet.',
                      ),
                    ),
                  );
                }

                if (driverState is DriverLocationError) {
                  return _MapContainer(
                    child: Center(
                      child: Text(driverState.message),
                    ),
                  );
                }

                if (driverState is DriverLocationSuccess) {
                  final driverLocation = LatLng(
                    driverState.location.latitude,
                    driverState.location.longitude,
                  );

                  if (hasDestination) {
                    final destination = LatLng(
                      destinationLatitude,
                      destinationLongitude,
                    );

                    _requestRouteIfNeeded(
                      driverLocation: driverLocation,
                      destination: destination,
                    );
                  }

                  return BlocBuilder<RoutingCubit, RoutingState>(
                    builder: (context, routingState) {
                      RouteModel? route;

                      if (routingState is RoutingSuccess) {
                        route = routingState.route;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LiveDriverMap(
                            location: driverState.location,
                            destination: hasDestination
                                ? LatLng(
                                    destinationLatitude,
                                    destinationLongitude,
                                  )
                                : null,
                            route: route,
                          ),
                          if (route != null) ...[
                            SizedBox(height: 12.h),
                            _RouteInfo(
                              distanceInKilometers:
                                  route.distanceInKilometers,
                              durationInMinutes: route.durationInMin,
                            ),
                          ],
                          if (!hasDestination) ...[
                            SizedBox(height: 12.h),
                            const _InfoCard(
                              child: Text(
                                'Delivery destination is not available.',
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }

  void _requestRouteIfNeeded({
    required LatLng driverLocation,
    required LatLng destination,
  }) {
    if (_lastRoutedDestination != null &&
        _lastRoutedDestination!.latitude == destination.latitude &&
        _lastRoutedDestination!.longitude == destination.longitude &&
        _lastRoutedDriverLocation != null) {
      final distance = const Distance().as(
        LengthUnit.Meter,
        _lastRoutedDriverLocation!,
        driverLocation,
      );

      if (distance < _routeRefreshDistanceInMeters) {
        return;
      }
    }

    _lastRoutedDriverLocation = driverLocation;
    _lastRoutedDestination = destination;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<RoutingCubit>().getRoute(
            driverLocation: driverLocation,
            destination: destination,
          );
    });
  }

  @override
  void dispose() {
    context.read<DriverLocationCubit>().stopWatching();
    context.read<RoutingCubit>().reset();
    super.dispose();
  }
}

class _DriverInfo extends StatelessWidget {
  final String driverId;

  const _DriverInfo({
    required this.driverId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _InfoCard(
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 12.w),
                const Text('Loading driver information...'),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return const _InfoCard(
            child: Text(
              'Unable to load driver information.',
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const _InfoCard(
            child: Text(
              'Driver information is not available.',
            ),
          );
        }

        final data = snapshot.data!.data();

        if (data == null) {
          return const _InfoCard(
            child: Text(
              'Driver information is not available.',
            ),
          );
        }

        final driverName = data['name']?.toString() ?? 'Unknown driver';
        final driverPhone = data['phone']?.toString() ?? '';

        return _InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    child: Icon(
                      Icons.person,
                      size: 25.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverName,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        if (driverPhone.isNotEmpty) ...[
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                driverPhone,
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ],
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

class _RouteInfo extends StatelessWidget {
  final double distanceInKilometers;
  final double durationInMinutes;

  const _RouteInfo({
    required this.distanceInKilometers,
    required this.durationInMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.route,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${distanceInKilometers.toStringAsFixed(1)} km',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${durationInMinutes.ceil()} min',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}

class _MapContainer extends StatelessWidget {
  final Widget child;

  const _MapContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}