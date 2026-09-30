import 'dart:async';
import 'dart:developer';
import 'package:e_commerce_full_project/core/di/injection_container.dart';
import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/domain/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCubit extends Cubit<List<OrderModel>> {
  final OrderRepo _orderRepository;
  StreamSubscription<List<OrderModel>>?
      _ordersSubscription; 
  OrderCubit(this._orderRepository) : super([]);
   
  Future<void> getOrders() async {
    try {
      final orders = await _orderRepository.getOrders();

      emit(orders); 
     
     _startWatchingOrders();


      log('Orders loaded successfully: ${orders.length}');
    } catch (e) {
      log('Failed to load orders: $e');
    }
  } 

  void _startWatchingOrders() {
    _ordersSubscription?.cancel();

    _ordersSubscription =
        _orderRepository.watchOrders().listen(
      (orders) {
        emit(orders);

        log(
          'Orders updated in real time: ${orders.length}',
        );
      },
      onError: (error) {
        log(
          'Orders stream error: $error',
        );
      },
    );
  }

  Future<void> addOrder({
    required List<CartItemModel> products,
    String? id,
    required double totalPrice,
    required String address,
    required String paymentMethod,
    required String paymentStatus,
    required String recipientName,
    required String recipientPhone,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? deliveryNotes,
  }) async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('User is not logged in');
      }

      if (recipientName.trim().isEmpty || recipientPhone.trim().isEmpty) {
        throw Exception('Recipient name and phone are required');
      }

      if ((deliveryLatitude == null) != (deliveryLongitude == null)) {
        throw Exception('Delivery location is incomplete');
      }

      final order = OrderModel(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        products: products,
        totalPrice: totalPrice,
        address: address,
        status: 'placed',
        date: DateTime.now(),
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus.toLowerCase(),
        recipientName: recipientName.trim(),
        recipientPhone: recipientPhone.trim(),
        deliveryLatitude: deliveryLatitude,
        deliveryLongitude: deliveryLongitude,
        deliveryNotes: deliveryNotes?.trim(),
      );

      await _orderRepository.addOrder(order);

      emit([...state, order]);

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

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }

}