import 'package:e_commerce_admin/features/Myorders/constants/order_status.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/order_product_model.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/order_user_model.dart';
import 'package:e_commerce_admin/features/Myorders/presentation/cubit/order_cubit.dart';
import 'package:e_commerce_admin/features/Myorders/presentation/cubit/order_state.dart';
import 'package:e_commerce_admin/features/delivery/data/model/Admin_driver_model.dart';
import 'package:e_commerce_admin/features/delivery/presentation/cubit/driver_cubit.dart';
import 'package:e_commerce_admin/features/delivery/presentation/cubit/states/driver_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState
    extends State<OrderDetailsScreen> {
  late String _selectedStatus;
  bool _isUpdating = false;
    AdminDriverModel? _selectedDriver; 
    OrderUserModel? _currentUser; 
    OrderModel? _currentOrder;
  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status; 
       _currentOrder = widget.order;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().getOrderDetails(
            userId: widget.order.userId,
            orderId: widget.order.id,
          ); 
      context.read<DriverCubit>().getAvailableDrivers();

    });
  }
Future<void> _assignDriver(OrderModel order) async {
  final driver = _selectedDriver;

  if (driver == null) {
    return;
  }

  setState(() {
    _isUpdating = true;
  });

  final success =
      await context.read<OrderCubit>().assignDriverToOrder(
            userId: order.userId,
            orderId: order.id,
            driverId: driver.driverId,
            driverName: driver.driverName,
          );

  if (!mounted) return;

  setState(() {
    _isUpdating = false;
  });

  if (success) {
    setState(() {
      _selectedDriver = null;
    });

    context.read<DriverCubit>().getAvailableDrivers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Driver assigned successfully',
        ),
      ),
    );
  }
}
  Future<void> _changeStatus(
    String status,
  ) async {
    if (status == _selectedStatus) {
      return;
    }
    setState(() {
      _isUpdating = true;
    });
    final success =
        await context.read<OrderCubit>().updateOrderStatus(
              userId: widget.order.userId,
              orderId: widget.order.id,
              status: status,
            );
    if (!mounted) return;
    setState(() {
      _isUpdating = false;
    });
    if (success) {
      setState(() {
        _selectedStatus = status;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Order status updated successfully',
          ),
        ),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;

      case OrderStatus.cancelled:
        return Colors.red;

      case OrderStatus.shipping:
        return Colors.blue;

      case OrderStatus.backInTransit:
        return Colors.deepOrange;

      case OrderStatus.arriveToday:
        return Colors.purple;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }

          if (state is OrderDetailsSuccess) {
            setState(() {
              _currentOrder = state.order;
              _currentUser = state.user;
              _selectedStatus = state.order.status;
            });
          }
        },
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

         if (state is OrderError && _currentOrder == null) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.error_outline,
          size: 50,
        ),
        const SizedBox(height: 12),
        Text(
          state.message,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            context.read<OrderCubit>().getOrderDetails(
                  userId: widget.order.userId,
                  orderId: widget.order.id,
                );
          },
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}

if (state is OrderDetailsSuccess) {
  return _buildContent(
    context,
    state.order,
    state.user,
  );
}

if (_currentOrder != null) {
  return _buildContent(
    context,
    _currentOrder!,
    _currentUser,
  );
}

return const Center(
  child: CircularProgressIndicator(),
);
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OrderModel order,
    OrderUserModel? user,
  ) {
    final statusColor = _statusColor(
      _selectedStatus,
    );

    final date = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(order.date!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Order Information',
            child: Column(
              children: [
                _infoRow(
                  'Order ID',
                  order.id,
                ),
                _infoRow(
                  'Date',
                  date,
                ),
                _infoRow(
                  'Payment',
                  order.paymentMethod.isEmpty
                      ? 'Not specified'
                      : order.paymentMethod,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            statusColor.withOpacity(.12),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        OrderStatus.label(
                          _selectedStatus,
                        ),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration:
                      const InputDecoration(
                    labelText: 'Change Status',
                    border: OutlineInputBorder(),
                  ),
                  items: OrderStatus.values
                      .map(
                        (status) =>
                            DropdownMenuItem<String>(
                          value: status,
                          child: Text(
                            OrderStatus.label(
                              status,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _isUpdating
                      ? null
                      : (value) {
                          if (value != null) {
                            _changeStatus(value);
                          }
                        },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Customer Information',
            child: Column(
              children: [
                _infoRow(
                  'Name',
                  user?.name.isNotEmpty == true
                      ? user!.name
                      : 'Not available',
                ),
                _infoRow(
                  'Email',
                  user?.email.isNotEmpty == true
                      ? user!.email
                      : 'Not available',
                ),
                _infoRow(
                  'Phone',
                  user?.phone.isNotEmpty == true
                      ? user!.phone
                      : 'Not available',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Shipping Address',
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.address.isEmpty
                        ? 'No address available'
                        : order.address,
                    style: const TextStyle(
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ), 
      _buildSection(
  title: 'Delivery Driver',
  child: BlocBuilder<DriverCubit, DriverState>(
    builder: (context, state) {
      if (order.driverId != null &&
          order.driverId!.isNotEmpty) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delivery_dining,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.driverName ?? 'Unknown Driver',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Assigned Driver',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (order.assignedAt != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    _infoRow(
                      'Assigned At',
                      DateFormat(
                        'dd MMM yyyy, hh:mm a',
                      ).format(order.assignedAt!),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }

      if (state is DriverLoading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (state is DriverError) {
        return Column(
          children: [
            Text(
              state.message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context
                    .read<DriverCubit>()
                    .getAvailableDrivers();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      }

      if (state is DriverSuccess) {
        if (state.drivers.isEmpty) {
          return const Text(
            'No available drivers at the moment.',
          );
        }

        return Column(
          children: [
            DropdownButtonFormField<AdminDriverModel>(
              value: _selectedDriver,
              decoration: const InputDecoration(
                labelText: 'Select Driver',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.delivery_dining,
                ),
              ),
              items: state.drivers.map((driver) {
                return DropdownMenuItem<AdminDriverModel>(
                  value: driver,
                  child: Text(driver.driverName),
                );
              }).toList(),
              onChanged: (driver) {
                setState(() {
                  _selectedDriver = driver;
                });
              },
            ),

            const SizedBox(height: 16),

        SizedBox(
  width: double.infinity,
  height: 48,
  child: ElevatedButton.icon(
    onPressed: _selectedDriver == null || _isUpdating
        ? null
        : () {
            _assignDriver(order);
          },
    icon: _isUpdating
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : const Icon(
            Icons.assignment_ind_outlined,
          ),
    label: Text(
      _isUpdating
          ? 'Assigning...'
          : 'Assign Driver',
    ),
  ),
),
          ],
        );
      }

      return const Text(
        'No driver data available.',
      );
    },
  ),
),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Products',
            child: Column(
              children: order.products
                  .map(
                    (product) => _ProductItem(
                      product: product,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Order Summary',
            child: Column(
              children: [
                _infoRow(
                  'Products',
                  '${order.products.length}',
                ),
                _infoRow(
                  'Total',
                  '\$${order.totalPrice.toStringAsFixed(2)}',
                  valueBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    String title,
    String value, {
    bool valueBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: valueBold
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final OrderProductModel product;

  const _ProductItem({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: SizedBox(
              width: 80,
              height: 80,
              child: product.image.isEmpty
                  ? const Icon(
                      Icons.image_not_supported,
                    )
                  : Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return const Icon(
                          Icons
                              .image_not_supported,
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.isEmpty
                      ? 'Unnamed Product'
                      : product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Quantity: ${product.quantity}',
                ),
                if (product.selectedColor != null &&
                    product.selectedColor!.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4),
                    child: Text(
                      'Color: ${product.selectedColor}',
                    ),
                  ),
                if (product.selectedSize != null &&
                    product.selectedSize!.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4),
                    child: Text(
                      'Size: ${product.selectedSize}',
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
