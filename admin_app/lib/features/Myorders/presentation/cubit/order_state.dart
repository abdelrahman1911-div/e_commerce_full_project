import 'package:equatable/equatable.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/order_user_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderModel> orders;

  const OrderSuccess(
    this.orders,
  );

  @override
  List<Object?> get props => [
        orders,
      ];
}

class OrderUpdating extends OrderState {
  final List<OrderModel> orders;
  final String orderId;

  const OrderUpdating({
    required this.orders,
    required this.orderId,
  });

  @override
  List<Object?> get props => [
        orders,
        orderId,
      ];
}

class OrderDetailsLoading extends OrderState {}

class OrderDetailsSuccess extends OrderState {
  final OrderModel order;
  final OrderUserModel? user;

  const OrderDetailsSuccess({
    required this.order,
    required this.user,
  });

  @override
  List<Object?> get props => [
        order,
        user,
      ];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(
    this.message,
  );

  @override
  List<Object?> get props => [
        message,
      ];
}
