import 'package:e_commerce_admin/features/Myorders/domain/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_admin/features/Myorders/presentation/cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _repository;

  OrderCubit(this._repository) : super(OrderInitial());

  Future<void> getAllOrders() async {
    try {
      emit(OrderLoading());

      final orders = await _repository.getAllOrders();

      emit(OrderSuccess(orders));
    } catch (e) {
      emit(OrderError(_getErrorMessage(e)));
    }
  }

  Future<bool> updateOrderStatus({
    required String userId,
    required String orderId,
    required String status,
  }) async {
    try {
      await _repository.updateOrderStatus(
        userId: userId,
        orderId: orderId,
        status: status,
      );

      if (state is OrderDetailsSuccess) {
        final currentState = state as OrderDetailsSuccess;

        final updatedOrder = currentState.order.copyWith(
          status: status,
        );

        emit(
          OrderDetailsSuccess(
            order: updatedOrder,
            user: currentState.user,
          ),
        );
      }

      return true;
    } catch (e) {
      emit(
        OrderError(
          _getErrorMessage(e),
        ),
      );

      return false;
    }
  }

  Future<void> getOrderDetails({
    required String userId,
    required String orderId,
  }) async {
    try {
      emit(OrderDetailsLoading());

      final order = await _repository.getOrderById(
        userId: userId,
        orderId: orderId,
      );

      if (order == null) {
        throw Exception('Order not found');
      }

      final user = await _repository.getOrderUser(
        userId: userId,
      );

      emit(
        OrderDetailsSuccess(
          order: order,
          user: user,
        ),
      );
    } catch (e) {
      emit(
        OrderError(
          _getErrorMessage(e),
        ),
      );
    }
  }
 Future<bool> assignDriverToOrder({
  required String userId,
  required String orderId,
  required String driverId,
  required String driverName,
}) async {
  try {
    await _repository.assignDriverToOrder(
      userId: userId,
      orderId: orderId,
      driverId: driverId,
      driverName: driverName,
    );

    final updatedOrder =
        await _repository.getOrderById(
      userId: userId,
      orderId: orderId,
    );

    if (updatedOrder == null) {
      throw Exception(
        'Failed to load updated order.',
      );
    }

    if (state is OrderDetailsSuccess) {
      final currentState =
          state as OrderDetailsSuccess;
      emit(
        OrderDetailsSuccess(
          order: updatedOrder,
          user: currentState.user,
        ),
      );
    }
    return true;
  } catch (e) {
    emit(
      OrderError(
        _getErrorMessage(e),
      ),
    );

    return false;
  }
}
  String _getErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }
}
