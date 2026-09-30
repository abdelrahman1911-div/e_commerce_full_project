import 'package:e_commerce_admin/core/router/app_routes.dart';
import 'package:e_commerce_admin/features/Myorders/constants/order_status.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_admin/features/Myorders/presentation/cubit/order_cubit.dart';
import 'package:e_commerce_admin/features/Myorders/presentation/cubit/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().getAllOrders();
    });
  }

  Future<void> _openOrderDetails(BuildContext context, OrderModel order) async {
    await context.push(AppRoutes.orderDetails, extra: order);

    if (!context.mounted) return;

    await context.read<OrderCubit>().getAllOrders();
  }
 void _goBackToDashboard(BuildContext context) { if (context.canPop()) { context.pop(); } else { context.go(AppRoutes.admin); } }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( leading: IconButton( icon: const Icon( Icons.arrow_back, ), onPressed: () { _goBackToDashboard(context); }, ), title: const Text( 'Orders', style: TextStyle( fontWeight: FontWeight.bold, ), ), ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            setState(() {
              _orders = state.orders;
            });
          }

          if (state is OrderError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is OrderLoading && _orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderError && _orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrderCubit>().getAllOrders();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }
          return RefreshIndicator(
            onRefresh: () {
              return context.read<OrderCubit>().getAllOrders();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                return _OrderCard(
                  order: _orders[index],
                  onOpenDetails: () {
                    _openOrderDetails(context, _orders[index]);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onOpenDetails;

  const _OrderCard({required this.order, required this.onOpenDetails});

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
    final statusColor = _statusColor(order.status);

    final date = DateFormat('dd MMM yyyy, hh:mm a').format(order.date!);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onOpenDetails,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      OrderStatus.label(order.status),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text('${order.products.length} products'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.payments_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '\$${order.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.address.isEmpty ? 'No address' : order.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onOpenDetails,
                  child: const Text('View Order Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
