import 'dart:async';
import 'package:e_commerce_delivery_app/core/errors/widget/user_error_overlay.dart';
import 'package:e_commerce_delivery_app/core/services/location_service.dart';
import 'package:e_commerce_delivery_app/core/utils/maps_launcher.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/cubit/cubit/auth_cubit.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/cubit/cubit/state/auth_state.dart';
import 'package:e_commerce_delivery_app/features/driver/data/models/driver_model.dart';
import 'package:e_commerce_delivery_app/features/driver/data/models/driver_order_model.dart';
import 'package:e_commerce_delivery_app/features/driver/presentations/cubit/driver_cubit.dart';
import 'package:e_commerce_delivery_app/features/driver/presentations/cubit/states/driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';

class DeliveryHomeScreen extends StatefulWidget {
 
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      final driverId = authState.user.uid;
      context.read<DriverCubit>().startDriver(driverId);
    }
  }

  StreamSubscription<LocationData>? _locationSubscription;
  Future<void> _startLocationTracking(String driverId) async {
    final started = await LocationService.startTracking();
    if (!started || !mounted) {
      UserErrorOverlay.show(
        context,
        message: 'location permission is required',
        isSuccess: false,
      );
      return;
    }
    await _locationSubscription?.cancel();
    _locationSubscription = LocationService.locationStream.listen((
      locationData,
    ) async {
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;
      // if (latitude == null || longitude == null) {
      //   return;
      // }

      await context.read<DriverCubit>().updateLocation(
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
      );
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        if (state is DriverLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is DriverError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is DriverSuccess) {
          return _buildHome(context, state.driver, state.order);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildHome(
    BuildContext context,
    DriverModel driver,
    DriverOrderModel? order,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            const Text('👋', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi,',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    driver.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Text(
                driver.isAvailable ? 'متاح' : 'غير متاح',
                style: TextStyle(
                  color: driver.isAvailable ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Switch(
                value: driver.isAvailable,
                activeColor: Colors.green,
                onChanged: (value) {
                  context.read<DriverCubit>().updateAvailability(
                    driverId: driver.id,
                    isAvailable: value,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStats(),

            const SizedBox(height: 24),

            const Text(
              'الطلب الحالي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (order == null)
              _buildNoOrder()
            else
              _buildCurrentOrder(order, driver),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(title: 'أرباح اليوم', value: '350 ج.م'),
          _StatDivider(),
          _StatItem(title: 'الطلبات', value: '8'),
          _StatDivider(),
          _StatItem(title: 'التقييم', value: '4.9 ★'),
        ],
      ),
    );
  }

  Widget _buildNoOrder() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.delivery_dining, size: 55, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'لا يوجد طلب حالي',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'عند تعيين طلب لك من الإدارة سيظهر هنا تلقائيًا.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentOrder(DriverOrderModel order, DriverModel driver) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                _StatusBadge(status: order.status),

                Text(
                  '#${order.id}',

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,

                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const Divider(height: 28),

            _OrderInfoRow(
              icon: Icons.person,

              iconColor: Colors.blue,

              title: 'المستلم',

              value: order.recipientName,
            ),

            const SizedBox(height: 14),

            _OrderInfoRow(
              icon: Icons.phone,

              iconColor: Colors.green,

              title: 'رقم الهاتف',

              value: order.recipientPhone,
            ),

            const SizedBox(height: 14),

            _OrderInfoRow(
              icon: Icons.location_on,

              iconColor: Colors.red,

              title: 'العنوان',

              value: order.address,
            ),
            if (order.deliveryNotes.isNotEmpty) ...[
              const SizedBox(height: 14),

              _OrderInfoRow(
                icon: Icons.notes,

                iconColor: Colors.orange,

                title: 'ملاحظات التوصيل',

                value: order.deliveryNotes,
              ),
            ],

            const Divider(height: 28),
            Row(
              children: [
                Expanded(
                  child: _OrderSummaryItem(
                    title: 'الإجمالي',

                    value: '${order.totalPrice} ج.م',
                  ),
                ),

                Expanded(
                  child: _OrderSummaryItem(
                    title: 'الدفع',

                    value: order.paymentMethod,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            _OrderSummaryItem(title: 'حالة الدفع', value: order.paymentStatus),

            const SizedBox(height: 20),

            Row(
              children: [
                SizedBox(
                  width: 150.w,

                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,

                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(vertical: 13),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () async {
                      await _startLocationTracking(driver.id);

                      await context.read<DriverCubit>().updateOrderStatus(
                        userId: order.userId,
                        orderId: order.id,
                        status: "shipping",
                      );

                      try {
                        await MapsLauncher.openDirections(
                          destination: order.address,
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        UserErrorOverlay.show(
                          context,
                          message: 'could not open maps',
                          isSuccess: false,
                        );
                      }
                    },

                    icon: const Icon(Icons.location_on),

                    label: const Text('متابعة موقع التوصيل'),
                  ),
                ),
                SizedBox(width: 5.w),
                SizedBox(
                  width: 150.w,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await context.read<DriverCubit>().completeOrder(
                        userId: order.userId,
                        orderId: order.id,
                      );
                      await context.read<DriverCubit>().updateAvailability(
                        driverId: driver.id,
                        isAvailable: true,
                      );
                    },
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: const Text('تم توصيل الطلب'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 30, width: 1, color: Colors.white24);
  }
}

class _OrderInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _OrderInfoRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? 'غير متوفر' : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderSummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _OrderSummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    switch (status) {
      case 'assigned':
        text = 'تم التعيين';
        color = Colors.blue;
        break;
      case 'accepted':
        text = 'تم القبول';
        color = Colors.orange;
        break;
      case 'picked_up':
        text = 'تم الاستلام';
        color = Colors.deepPurple;
        break;
      case 'on_the_way':
        text = 'جاري التوصيل';
        color = Colors.orange;
        break;
      case 'delivered':
        text = 'تم التسليم';
        color = Colors.green;
        break;
      default:
        text = status;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
