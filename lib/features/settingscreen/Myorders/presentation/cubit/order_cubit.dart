import 'dart:developer';

import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/domain/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCubit extends Cubit<List<OrderModel>> {
  final OrderRepo _orderRepository;

  OrderCubit(this._orderRepository) : super([]);

  Future<void> getOrders() async {
    try {
      final orders = await _orderRepository.getOrders();

      emit(orders);

      log('Orders loaded successfully: ${orders.length}');
    } catch (e) {
      log('Failed to load orders: $e');
    }
  }

  Future<void> addOrder({
    required List<CartItemModel> products,
    String? id,
    required double totalPrice,
    required String address,
    required String paymentMethod,
  }) async {
    try {
      final order = OrderModel(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        products: products,
        totalPrice: totalPrice,
        address: address,
        status: 'pending',
        paymentMethod: paymentMethod,
        date: DateTime.now(),
      );

      await _orderRepository.addOrder(order);

      emit([
        ...state,
        order,
      ]);

      log('Order added successfully: ${order.id}');
    } catch (e) {
      log('Failed to add order: $e');
      rethrow;
    }
  }

  Future<void> removeOrder(String orderId) async {
    try {
      await _orderRepository.removeOrder(orderId);

      final updatedOrders = state
          .where((order) => order.id != orderId)
          .toList();

      emit(updatedOrders);

      log('Order removed successfully: $orderId');
    } catch (e) {
      log('Failed to remove order: $e');
    }
  }

  List<CartItemModel> getOrderProducts(String orderId) {
    try {
      final order = state.firstWhere(
        (order) => order.id == orderId,
      );

      return order.products;
    } catch (e) {
      return [];
    }
  }

  Future<void> clearOrders() async {
    try {
      await _orderRepository.clearOrders();

      emit([]);

      log('Orders cleared successfully');
    } catch (e) {
      log('Failed to clear orders: $e');
    }
  }
}